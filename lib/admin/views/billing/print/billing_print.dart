// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:agus/admin/models/billing_members_models.dart';
import 'package:agus/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillingPring extends HookWidget {
  final String docID;
  const BillingPring({Key? key, required this.docID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billingMember = useState<List<BillingMember>>([]);

    useEffect(() {
        Future.microtask(() async {
          billingMember.value = await getBills();
        });
        return;
      },[docID],);

    return Scaffold(
      appBar: AppBar(title: Text('Billing Print')),
      body: PdfPreview(
        build: (format) =>
            _generatePdf(context, format, 'Billing Print', billingMember),
      ),
    );
  }

  Future<List<BillingMember>> getBills() async {
    List<BillingMember> billingMember = [];
    if (docID.isEmpty) {
      return [];
    }

    await FirebaseFirestore.instance
        .collection('billing')
        .doc(docID)
        .collection('members')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
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
                );

                billingMember.add(bill);
              })
            });
    print(billingMember.length);
    return billingMember;
  }

  Future<Uint8List> _generatePdf(BuildContext context, PdfPageFormat format,
      String title, ValueNotifier billingMember) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
             
              pw.Container(child: pw.Text('Piwas Billing')),
              pw.SizedBox(height: 20),
              pw.Column(
                    children: [
                      pw.Container(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                flex: 4,
                                child: pw.Text(
                                  'Name',
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text('Previous ',
                                    ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text('Current ',
                                    ),
                              ),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Text('Total Cubic',
                                  ),
                              ),
                              pw.Expanded(
                                flex: 3,
                                child: pw.Text('Billing Price',
                                  ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text('Status',
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              pw.Divider(),
              pw.Flexible(
                  child: pw.ListView.builder(
                      itemCount: billingMember.value.length,
                      itemBuilder: (context, index) {
                        // return pw.Text(billingMember.value[index].name);
                        return pw.Column(children: [
                          pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Expanded(
                                      flex: 4,
                                      child: pw.Text(
                                        billingMember.value[index].name,
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                          billingMember.value[index].previousReading
                                              .toString(),
                                          ),
                                    ),
                                    pw.Expanded(
                                      flex: 2,
                                      child:  pw.Text(
                                            billingMember.value[index].currentReading
                                                .toString(),
                                            ),
                                    ),

                                  
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                          billingMember.value[index].totalCubic.toStringAsFixed(2),
                                         ),
                                    ),
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                            'Php ${billingMember.value[index].billingPrice.toStringAsFixed(2)}',
                                            ),
                                    ),
                                    pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(billingMember.value[index].status,
                                          ),
                                    ),
                                  ],
                                ),
                                pw.Divider()
                        ]);
                      }))
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
