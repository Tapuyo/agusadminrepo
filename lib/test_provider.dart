import 'package:agus/providers/test_provider.dart';
import 'package:agus/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class TestProviderWidget extends HookWidget{
  

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TestProvider>();
    final counter = useState<double>(prov.iscount);

    useEffect(() {
      Future.microtask(()  {
        counter.value = prov.iscount;
      });
      return;
    },  [prov.iscount]);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: (){
          final provider = context.read<TestProvider>();
          provider.countAdd(200);
        }, icon: Icon(Icons.add)),
        SizedBox(height: 10,),
        TextValueCount(counter: counter),
      ],
    );
  }
}
