import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';

class SwipeableWidget extends StatefulWidget {
  const SwipeableWidget({
    Key? key,
    required this.child,
    this.swipedWidget,
    this.maxOffset,
    this.enabled = true,
    this.canLongPress = false,
    this.resetOnRelease = false,
    this.onStateChanged,
    this.alignment = Alignment.center,
    this.swipeRight = false,
    this.onRelease,
    this.isMeetingType=false,
    this.meeting
  }) : super(key: key);

  final Alignment alignment;
  final bool resetOnRelease, enabled;
  final bool canLongPress;
  final bool? swipeRight;
  final bool isMeetingType;

  final double? maxOffset;
  final Widget? swipedWidget;
  final Widget child;
  final Meeting? meeting;

  final Function(bool isOpen)? onStateChanged;
  final Function()? onRelease;

  @override
  State<SwipeableWidget> createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animator;
  final curveAnim = CurveTween(curve: Curves.easeInBack);

  bool isOpen = false;
  double offset = 0, initialOffset = 0, lastOffset = 0;
  late double maxOffset;

  @override
  void initState() {
    animator = AnimationController(vsync: this, duration: kTabScrollDuration)
      ..addListener(() {
        log('animationChanged');
        // On animation changed, check if widget is open else set the toPosition to lastOffset
        var toPosition = isOpen ? maxOffset : lastOffset;
        var val = curveAnim.animate(animator).value;
        //set to value of the offset to toPosition * val;
        setState(() => offset = toPosition * val);
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.swipeRight!) {
      maxOffset =
      -(widget.maxOffset ?? MediaQuery.of(context).size.width * 0.15);
    } else {
      maxOffset = (widget.maxOffset ?? 20);
    }
  }

  @override
  void didUpdateWidget(covariant SwipeableWidget oldWidget) {
    if (!widget.resetOnRelease) _animateTo(false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animator.dispose();
    super.dispose();
  }

  Future _animateTo(bool end) async {
    isOpen = end;
    lastOffset = offset;
    widget.onStateChanged?.call(end);
    if (widget.resetOnRelease && end) {
      animator.reset();
      await animator.animateTo(1, curve: Curves.linear);
      await animator.animateTo(0, curve: Curves.linear);
      return;
    }
    if (end) {
      await animator.forward(from: 0);
    } else {
      await animator.reverse(from: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = offset / maxOffset;

    return Stack(
      alignment: widget.alignment,
      children: [
        if (widget.swipedWidget != null)
          Transform.scale(
            scale: percentage * 0.3 + 0.7,
            child: Opacity(
              opacity: Curves.easeIn.transform(percentage.clamp(0, 1)),
              child: Listener(
                onPointerUp: (_) => _animateTo(false),
                behavior: HitTestBehavior.translucent,
                child: widget.swipedWidget!,
              ),
            ),
          ),
        if (widget.enabled)
          GestureDetector(
            onTap: () {
              if (isOpen && !widget.resetOnRelease) _animateTo(false);
            },
            onHorizontalDragStart: (details) =>
            initialOffset = details.localPosition.dx,
            onHorizontalDragUpdate:
                (details) {
              if(widget.meeting!.status == "cancelled"){
                showDialog(context: context,
                    builder: (context)=> AlertDialog(
                      content: Text(
                         "You already cancelled this meeting"
                      ),
                    )
                );
              }
              else if(widget.meeting!.isExpired){
                showDialog(context: context,
                    builder: (context)=> AlertDialog(
                      content: Text(
                          "You can only cancel a meeting 8 hours or more before the scheduled meeting time"
                      ),
                    )
                );
              }
              else{
                //if the swipe axis is right
                if (widget.swipeRight!) {
                  if (details.localPosition.dx > initialOffset) {
                    if (offset < maxOffset) {
                      setState(() {
                        offset = details.localPosition.dx - initialOffset;
                      });
                    } else {
                      setState(() => offset = maxOffset);
                    }
                  }
                  else if (isOpen) {
                    _animateTo(true);
                  }
                }
                else {
                  //If user Swipes left
                  if (details.localPosition.dx < initialOffset) {
                    if (offset > maxOffset) {
                      log('INITIAL OFFSET :$initialOffset');
                      log(' OFFSET :$offset');
                      log('MAX OFFSET :$maxOffset');
                      log('Location :${details.localPosition.dx}');
                      setState(() {
                        offset = details.localPosition.dx - initialOffset;
                      });
                    } else {
                      setState(() => offset = maxOffset);
                    }
                  } else if (isOpen) {
                    _animateTo(false);
                  }
                }
              }
            },
            onLongPress: (){
              if(widget.isMeetingType ==false){
                widget.canLongPress ? () => _animateTo(!isOpen) : null;
              }
              else{
                // showDialog(
                //   context: context,
                //   builder: (_) =>
                //       MeetingDialog(
                //         meeting: widget.meeting!,
                //         consultant: Consultant(
                //             id: widget.meeting!.consultant.id,
                //             firstName: widget.meeting!.consultant.firstName,
                //             lastName: widget.meeting!.consultant.lastName
                //     ),
                //   ),
                // );
              }
            },
            onHorizontalDragCancel: () => _animateTo(false),
            onHorizontalDragEnd: (details) {
              if (offset > maxOffset || widget.resetOnRelease) {
                if (widget.onRelease != null) {
                  widget.onRelease!();
                }
                _animateTo(false);
              }
              if (offset <= maxOffset) {

                widget.onStateChanged?.call(isOpen = true);
              }
            },
            child: Transform.translate(
              offset: Offset(offset, 0),
              child: widget.child,
            ),
          )
        else
          widget.child,
      ],
    );
  }
}