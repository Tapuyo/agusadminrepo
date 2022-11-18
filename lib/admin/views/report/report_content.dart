import 'dart:js';
import 'dart:typed_data';

import 'package:agus/admin/models/area_models.dart';
import 'package:agus/admin/models/billing_members_models.dart';
import 'package:agus/admin/views/billing/dialog/billing_pay_dialog.dart';
import 'package:agus/admin/views/billing/dialog/flat_rate_dialog.dart';
import 'package:agus/constants/constant.dart';
import 'package:agus/providers/billings_provider.dart';
import 'package:agus/utils/custom_icon_button.dart';
import 'package:agus/utils/custom_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as PDF;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class ReportContentPage extends HookWidget {
  final String docID;
  final bool openBilling;
  final String billMonth;
  final String billYear;
  const ReportContentPage(
      {Key? key,
      required this.docID,
      required this.openBilling,
      required this.billMonth,
      required this.billYear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BillingsProvider>();
    final lock = useState<bool>(true);
    final fBilling = useState<Future?>(null);
    final billingMember = useState<List<BillingMember>>([]);
    final areaList = useState<List<Area>>([]);
    final areaSelected = useState<String>('All');
    List readUnread = ['All', 'Read', 'Unread'];
    List paidUnpaid = ['All', 'Paid', 'Unpaid'];
    List flatRat = ['All', 'Flat Rate', 'Non Flat Rate'];
    final readSelect = useState<String>(provider.read);
    final paidSelect = useState<String>(provider.paid);
    final flatRateSelect = useState<String>(provider.flatRate);
    final searchName = useState<String>(provider.issearchString);

    useEffect(() {
      if (openBilling) {
        lock.value = true;
      } else {
        lock.value = true;
      }
      Future.microtask(() async {
        await getAreaDropDown(areaList);
      });
    }, const []);

    useEffect(() {
      Future.microtask(() async {
        billingMember.value = await getArea(context, areaSelected.value);
      });
    },  [areaSelected.value, ]);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (areaList.value.isNotEmpty) ...[
                          const Text('Choose Area: '),
                          const SizedBox(
                            width: 8,
                          ),
                          DropdownButton(
                            hint: const Text(
                                'Choose area'), // Not necessary for Option 1
                            value: areaSelected.value,
                            onChanged: (newValue) {
                              areaSelected.value = newValue.toString();
                            },
                            items: areaList.value.map((area) {
                              return DropdownMenuItem(
                                child: Text(area.name),
                                value: area.id,
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(
                          width: 12,
                        ),
                        const Text('Reading status: '),
                        const SizedBox(
                          width: 8,
                        ),
                        DropdownButton(
                          hint: const Text(
                              'Status'), // Not necessary for Option 1
                          value: readSelect.value,
                          onChanged: (newValue) {
                            readSelect.value = newValue.toString();
                            provider.setRead(newValue.toString());
                          },
                          items: readUnread.map((read) {
                            return DropdownMenuItem(
                              child: Text(read),
                              value: read,
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text('Payment status: '),
                        const SizedBox(
                          width: 8,
                        ),
                        DropdownButton(
                          hint: const Text(
                              'Payment'), // Not necessary for Option 1
                          value: paidSelect.value,
                          onChanged: (newValue) {
                            paidSelect.value = newValue.toString();
                            provider.setPaid(newValue.toString());
                          },
                          items: paidUnpaid.map((read) {
                            return DropdownMenuItem(
                              child: Text(read),
                              value: read,
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text('Flatrate: '),
                        const SizedBox(
                          width: 8,
                        ),
                        DropdownButton(
                          hint: const Text(
                              'Flat Rate'), // Not necessary for Option 1
                          value: flatRateSelect.value,
                          onChanged: (newValue) {
                            flatRateSelect.value = newValue.toString();
                            provider.setFlatRate(newValue.toString());
                          },
                          items: flatRat.map((read) {
                            return DropdownMenuItem(
                              child: Text(read),
                              value: read,
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        CustomIconButton(
                            enableColor: Colors.grey.withOpacity(.5),
                            enable: true,
                            icon: Icons.clear,
                            key: key,
                            onPressed: () {
                              areaSelected.value = 'All';
                              readSelect.value = 'All';
                              flatRateSelect.value = 'All';
                              paidSelect.value = 'All';
                              provider.setClear();
                            },
                            text: 'Clear ',
                            elevation: 0,
                            textSize: 14,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      ],
                    ),
                    Divider(),
                    buildPdfReport(context, billingMember)
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<List<Area>> getAreaDropDown(ValueNotifier areaList) async {
    List<Area> areaTmp = [];

    await FirebaseFirestore.instance
        .collection('area')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                debugPrint(doc.id);
                Area area = Area(
                  doc.id,
                  doc['code'],
                  doc['name'],
                  doc['description'],
                  doc['status'],
                  doc['date'].toString(),
                );

                areaTmp.add(area);
              })
            });
    Area areaAll = Area(
      'All',
      'All',
      'All',
      'All',
      'All',
      'All',
    );
    areaTmp.add(areaAll);
    areaList.value = areaTmp;
    return areaList.value;
  }

  Future<List<BillingMember>> getArea(
      BuildContext context, String areaSelected) async {
    List<BillingMember> billingMember = [];
    final provider = context.read<BillingsProvider>();
    final isRead = provider.isRead;
    final isPaid = provider.isPaid;
    final isFlatRate = provider.isFlateRate;
    final searchString = provider.issearchString;

    if (docID.isEmpty) {
      return [];
    }

    if (areaSelected.isEmpty || areaSelected == 'All') {
      await FirebaseFirestore.instance
          .collection('membersBilling')
          .where('billingId', isEqualTo: docID)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) async {
                  DateTime dateBill = (doc['dateBill'] as Timestamp).toDate();
                  DateTime dueBalance =
                      (doc['dueDateBalance'] as Timestamp).toDate();
                  BillingMember bill = BillingMember(
                      doc.id,
                      doc['memberId'].toString(),
                      doc['name'].toString(),
                      doc['areaId'].toString(),
                      doc['connectionId'].toString(),
                      doc['previousReading'],
                      doc['currentReading'],
                      doc['dateRead'].toString(),
                      doc['totalCubic'],
                      doc['billingPrice'],
                      doc['flatRate'].toString(),
                      doc['flatRatePrice'],
                      doc['status'].toString(),
                      doc['toBill'],
                      doc['balance'],
                      dateBill.toString(),
                      dueBalance.toString());
                  if (isRead == 'All') {
                    if (isPaid == 'All') {
                      if (isFlatRate == 'All') {
                        if (doc['name'].toString().contains(searchString)) {
                          billingMember.add(bill);
                        }
                      } else if (isFlatRate == 'Flat Rate') {
                        if (doc['flatRatePrice'] > 0) {
                          if (doc['name'].toString().contains(searchString)) {
                            billingMember.add(bill);
                          }
                        }
                      } else {
                        if (doc['flatRatePrice'] <= 0) {
                          if (doc['name'].toString().contains(searchString)) {
                            billingMember.add(bill);
                          }
                        }
                      }
                    } else {
                      if (isPaid == 'Paid') {
                        if (doc['status'] == 'paid') {
                          if (isFlatRate == 'All') {
                            if (doc['name'].toString().contains(searchString)) {
                              billingMember.add(bill);
                            }
                          } else if (isFlatRate == 'Flat Rate') {
                            if (doc['flatRatePrice'] > 0) {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            }
                          } else {
                            if (doc['flatRatePrice'] <= 0) {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            }
                          }
                        }
                      } else {
                        if (doc['status'] == 'unpaid') {
                          if (isFlatRate == 'All') {
                            if (doc['name'].toString().contains(searchString)) {
                              billingMember.add(bill);
                            }
                          } else if (isFlatRate == 'Flat Rate') {
                            if (doc['flatRatePrice'] > 0) {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            }
                          } else {
                            if (doc['flatRatePrice'] <= 0) {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            }
                          }
                        }
                      }
                    }
                  } else if (isRead == 'Read') {
                    if (doc['currentReading'] > 0) {
                      if (isPaid == 'All') {
                        if (isFlatRate == 'All') {
                          if (doc['name'].toString().contains(searchString)) {
                            billingMember.add(bill);
                          }
                        } else if (isFlatRate == 'Flat Rate') {
                          if (doc['flatRatePrice'] > 0) {
                            if (doc['name'].toString().contains(searchString)) {
                              billingMember.add(bill);
                            }
                          }
                        } else {
                          if (doc['flatRatePrice'] <= 0) {
                            if (doc['name'].toString().contains(searchString)) {
                              billingMember.add(bill);
                            }
                          }
                        }
                      } else {
                        if (isPaid == 'Paid') {
                          if (doc['status'] == 'paid') {
                            if (isFlatRate == 'All') {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            }
                          }
                        } else {
                          if (doc['status'] == 'unpaid') {
                            if (isFlatRate == 'All') {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  } else {
                    if (doc['currentReading'] <= 0) {
                      if (isPaid == 'All') {
                        if (isFlatRate == 'All') {
                          if (doc['name'].toString().contains(searchString)) {
                            billingMember.add(bill);
                          }
                        } else if (isFlatRate == 'Flat Rate') {
                          if (doc['flatRatePrice'] > 0) {
                            if (doc['name'].toString().contains(searchString)) {
                              billingMember.add(bill);
                            }
                          }
                        } else {
                          if (doc['flatRatePrice'] <= 0) {
                            if (doc['name'].toString().contains(searchString)) {
                              billingMember.add(bill);
                            }
                          }
                        }
                      } else {
                        if (isPaid == 'Paid') {
                          if (doc['status'] == 'paid') {
                            if (isFlatRate == 'All') {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            }
                          }
                        } else {
                          if (doc['status'] == 'unpaid') {
                            if (isFlatRate == 'All') {
                              if (doc['name']
                                  .toString()
                                  .contains(searchString)) {
                                billingMember.add(bill);
                              }
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                if (doc['name']
                                    .toString()
                                    .contains(searchString)) {
                                  billingMember.add(bill);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                })
              });
    } else {
      await FirebaseFirestore.instance
          .collection('membersBilling')
          .where('billingId', isEqualTo: docID)
          .where('areaId', isEqualTo: areaSelected)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) async {
                  DateTime dateBill = (doc['dateBill'] as Timestamp).toDate();
                  DateTime dueBalance =
                      (doc['dueDateBalance'] as Timestamp).toDate();
                  BillingMember bill = BillingMember(
                      doc.id,
                      doc['memberId'].toString(),
                      doc['name'].toString(),
                      doc['areaId'].toString(),
                      doc['connectionId'].toString(),
                      doc['previousReading'],
                      doc['currentReading'],
                      doc['dateRead'].toString(),
                      doc['totalCubic'],
                      doc['billingPrice'],
                      doc['flatRate'].toString(),
                      doc['flatRatePrice'],
                      doc['status'].toString(),
                      doc['toBill'],
                      doc['balance'],
                      dateBill.toString(),
                      dueBalance.toString());

                  if (isRead == 'All') {
                    if (isPaid == 'All') {
                      if (isFlatRate == 'All') {
                        billingMember.add(bill);
                      } else if (isFlatRate == 'Flat Rate') {
                        if (doc['flatRatePrice'] > 0) {
                          billingMember.add(bill);
                        }
                      } else {
                        if (doc['flatRatePrice'] <= 0) {
                          billingMember.add(bill);
                        }
                      }
                    } else {
                      if (isPaid == 'Paid') {
                        if (doc['status'] == 'paid') {
                          if (isFlatRate == 'All') {
                            billingMember.add(bill);
                          } else if (isFlatRate == 'Flat Rate') {
                            if (doc['flatRatePrice'] > 0) {
                              billingMember.add(bill);
                            }
                          } else {
                            if (doc['flatRatePrice'] <= 0) {
                              billingMember.add(bill);
                            }
                          }
                        }
                      } else {
                        if (doc['status'] == 'unpaid') {
                          if (isFlatRate == 'All') {
                            billingMember.add(bill);
                          } else if (isFlatRate == 'Flat Rate') {
                            if (doc['flatRatePrice'] > 0) {
                              billingMember.add(bill);
                            }
                          } else {
                            if (doc['flatRatePrice'] <= 0) {
                              billingMember.add(bill);
                            }
                          }
                        }
                      }
                    }
                  } else if (isRead == 'Read') {
                    if (doc['currentReading'] > 0) {
                      if (isPaid == 'All') {
                        if (isFlatRate == 'All') {
                          billingMember.add(bill);
                        } else if (isFlatRate == 'Flat Rate') {
                          if (doc['flatRatePrice'] > 0) {
                            billingMember.add(bill);
                          }
                        } else {
                          if (doc['flatRatePrice'] <= 0) {
                            billingMember.add(bill);
                          }
                        }
                      } else {
                        if (isPaid == 'Paid') {
                          if (doc['status'] == 'paid') {
                            if (isFlatRate == 'All') {
                              billingMember.add(bill);
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                billingMember.add(bill);
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                billingMember.add(bill);
                              }
                            }
                          }
                        } else {
                          if (doc['status'] == 'unpaid') {
                            if (isFlatRate == 'All') {
                              billingMember.add(bill);
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                billingMember.add(bill);
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                billingMember.add(bill);
                              }
                            }
                          }
                        }
                      }
                    }
                  } else {
                    if (doc['currentReading'] <= 0) {
                      if (isPaid == 'All') {
                        if (isFlatRate == 'All') {
                          billingMember.add(bill);
                        } else if (isFlatRate == 'Flat Rate') {
                          if (doc['flatRatePrice'] > 0) {
                            billingMember.add(bill);
                          }
                        } else {
                          if (doc['flatRatePrice'] <= 0) {
                            billingMember.add(bill);
                          }
                        }
                      } else {
                        if (isPaid == 'Paid') {
                          if (doc['status'] == 'paid') {
                            if (isFlatRate == 'All') {
                              billingMember.add(bill);
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                billingMember.add(bill);
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                billingMember.add(bill);
                              }
                            }
                          }
                        } else {
                          if (doc['status'] == 'unpaid') {
                            if (isFlatRate == 'All') {
                              billingMember.add(bill);
                            } else if (isFlatRate == 'Flat Rate') {
                              if (doc['flatRatePrice'] > 0) {
                                billingMember.add(bill);
                              }
                            } else {
                              if (doc['flatRatePrice'] <= 0) {
                                billingMember.add(bill);
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                })
              });
    }
    return billingMember;
  }

  buildPdfReport(BuildContext context, ValueNotifier billMembers) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: PdfPreview(
          build: (context) => makePdf(billMembers),
        ),
      ),
    );
  }

  Future<Uint8List> makePdf(ValueNotifier billMembers) async {
    final pdf = PDF.Document();
    pdf.addPage(PDF.Page(build: (context) {
      return PDF.Column(children: [
        PDF.Row(mainAxisAlignment: PDF.MainAxisAlignment.center, children: [
          PDF.Text('PIWAS'),
        ]),
          PDF.Divider(thickness: 2),
          PDF.SizedBox(height: 15),
          PDF.Column(children: [printBody(billMembers)])
      ]);
    }));
    return pdf.save();
  }

  PDF.Widget printBody(ValueNotifier billMembers) {
    return PDF.Padding(padding: const PDF.EdgeInsets.all(8),child: PDF.ListView(children: [
        PDF.Row(
        mainAxisAlignment: PDF.MainAxisAlignment.spaceBetween,
        children: [
        PDF.SizedBox(width: 150, child: PDF.Text('Name'),),
        PDF.Text('Prev'),
        PDF.Text('Current'),
        PDF.Text('Total Cubic'),
        PDF.Text('Billing'),
        PDF.Text('Balance'),


       ]),
       PDF.Divider(),
      for (var i = 0; i < billMembers.value.length; i++) ...[

       PDF.Padding(padding: const PDF.EdgeInsets.fromLTRB(0, 5, 0, 5),
       child: PDF.Row(
        mainAxisAlignment: PDF.MainAxisAlignment.spaceBetween,
        children: [
        PDF.SizedBox(width: 150,child: PDF.Text(billMembers.value[i].name),),
        PDF.Text(billMembers.value[i].previousReading.toStringAsFixed(2)),
        PDF.Text(billMembers.value[i].currentReading.toStringAsFixed(2)),
        PDF.Text(billMembers.value[i].totalCubic.toStringAsFixed(2)),
        PDF.Text('Php ${billMembers.value[i].billingPrice.toStringAsFixed(2)}'),
        PDF.Text('Php ${billMembers.value[i].balance.toStringAsFixed(2)}'),


       ]))
    ]]),);
    
  }
}
