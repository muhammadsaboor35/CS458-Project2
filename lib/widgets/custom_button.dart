import 'package:flutter/material.dart';

double screenAwareSize(double size, BuildContext context) {
  return (size * 1.143) * (MediaQuery.of(context).size.width / 375);
}

double screenAwareProportionalHeight(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / 667;
}

double screenWidthPercent(double percent, BuildContext context) {
  return screenUsableWidth(context) * percent / 100;
}

double screenHeightPercent(double percent, BuildContext context) {
  return screenUsableHeight(context) * percent / 100;
}

double screenUsableHeight(BuildContext context) {
  var padding = MediaQuery.of(context).padding;
  return MediaQuery.of(context).size.height - padding.bottom - padding.top;
}

double screenUsableWidth(BuildContext context) {
  var padding = MediaQuery.of(context).padding;
  return MediaQuery.of(context).size.width - padding.right - padding.left;
}

class CustomButton extends StatelessWidget {
  final double width;
  final String text;
  final Function onTap;
  final bool loading;
  final Color color;
  final Widget leading;
  final double radius;

  CustomButton(
      {@required this.width,
      @required this.text,
      @required this.onTap,
      this.loading: false,
      this.color: Colors.blue,
      this.leading,
      this.radius: 50,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: screenAwareProportionalHeight(45, context),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            radius,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(splashColor: color.withOpacity(0.5)),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(screenAwareSize(2, context)),
                width: loading ? screenAwareProportionalHeight(45, context) : width,
                height: screenAwareProportionalHeight(45, context),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: loading
                      ? Padding(
                          padding: EdgeInsets.all(screenAwareSize(5, context)),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Row(
                          children: <Widget>[
                            leading == null
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenAwareSize(10, context)),
                                    child: leading),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: screenAwareSize(15, context), color: Colors.white),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                            leading == null
                                ? Container()
                                : Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenAwareSize(10, context)),
                                        child: leading),
                                  )
                          ],
                        ),
                ),
              ),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
