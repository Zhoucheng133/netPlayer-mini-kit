import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_miniplay/variables/data_var.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final DataVar d=Get.put(DataVar());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Obx(()=>
        Column(
          children: [
            Row(
              children: [
                d.cover.value.isNotEmpty ? Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image:  DecorationImage(
                      image: NetworkImage(d.cover.value),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ): const SizedBox(
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.title.value,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        d.artist.value,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600]
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  
                )
              ],
            )
          ],
        )
      ),
    );
  }
}