import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final Function (int) onChange;
  final int CurrentSlider;
  const ImageSlider({super.key, required this.CurrentSlider, required this.onChange});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 180, 
          width: double.infinity, 
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: PageView(
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              onPageChanged: onChange,
              physics: ClampingScrollPhysics(),
              children: [
                Image.asset("lib/images/slider4.jpeg", fit: BoxFit.cover),
                Image.asset("lib/images/slider2.jpeg", fit: BoxFit.cover),
                Image.asset("lib/images/slider1.jpeg", fit: BoxFit.cover),
                Image.asset("lib/images/slider3.jpeg", fit: BoxFit.cover),
                Image.asset("lib/images/slider5.jpeg", fit: BoxFit.cover),
              ]
            )
          ),
        ),
        Positioned.fill(
          bottom: 6,
          child: Align(
            alignment: Alignment.bottomCenter, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index)=> AnimatedContainer(
                  duration: Duration(microseconds: 300),
                  width: CurrentSlider == index? 15:8, 
                  height: 8,
                  margin: const EdgeInsets.only(right:3),
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(10,),
                    color: CurrentSlider == index? Colors.grey: Colors.transparent,
                    border: Border.all(color: Colors.grey),
                  )
                )
              )
            ),
          ),
        ),
      ]
    );
  }
}