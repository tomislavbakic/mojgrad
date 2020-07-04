import 'package:flutter/material.dart';
import 'package:fronend/config/config.error.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/logout.dart';
import 'package:fronend/functions/successfulActionDialog.dart';
import 'package:fronend/main.dart';
import 'package:fronend/screens/posts/newPostPage.dart';
import 'package:fronend/screens/routes/HomePage.dart';
import 'package:fronend/screens/routes/notifications.dart';
import 'package:fronend/screens/routes/searchPage.dart';
import 'package:fronend/screens/routes/userProfilPage.dart';
import 'package:fronend/services/api.services.user.dart';
import 'package:line_icons/line_icons.dart';

class MyBottomNavigationBar extends StatefulWidget {
  int value = 0;

  MyBottomNavigationBar(int value) {
    this.value = value;
  }

  @override
  _MyBottomNavigationBarState createState() =>
      _MyBottomNavigationBarState(value);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  _MyBottomNavigationBarState(value) {
    _currentIndex = value;
  }

  void callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
            .then((value) {
          print("PROMENA STRANE " + value.toString());
          if (value == null) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessfulActionDialog(
                    deletedAccountTitle, deletedAccountMSG);
              },
              barrierDismissible: false,
            ).then((value) {
              logoutUser(context);
            });
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        HomePage.city(cityID: LoggedUser.data.cityID)),
                (route) => false);
          }
        });

        break;
      case 1:
        APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
            .then((value) {
          print("PROMENA STRANE " + value.toString());
          if (value == null) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessfulActionDialog(
                    deletedAccountTitle, deletedAccountMSG);
              },
              barrierDismissible: false,
            ).then((value) {
              logoutUser(context);
            });
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => NotificationsPage()),
                (route) => false);
          }
        });

        break;
      case 2:
        APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
            .then((value) {
          print("PROMENA STRANE " + value.toString());
          if (value == null) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessfulActionDialog(
                    deletedAccountTitle, deletedAccountMSG);
              },
              barrierDismissible: false,
            ).then((value) {
              logoutUser(context);
            });
          } else {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => NewPost()), (route) => false);
          }
        });

        break;
      case 3:
        APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
            .then((value) {
          print("PROMENA STRANE " + value.toString());
          if (value == null) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessfulActionDialog(
                    deletedAccountTitle, deletedAccountMSG);
              },
              barrierDismissible: false,
            ).then((value) {
              logoutUser(context);
            });
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => SearchPage()),
                (route) => false);
          }
        });
        break;
      case 4:
        APIServicesUsers.fetchUserDataByID(globalJWT, LoggedUser.id)
            .then((value) {
          print("PROMENA STRANE " + value.toString());
          if (value == null) {
            showDialog(
              context: context,
              builder: (context) {
                return SuccessfulActionDialog(
                    deletedAccountTitle, deletedAccountMSG);
              },
              barrierDismissible: false,
            ).then((value) {
              logoutUser(context);
            });
          } else {
            UserProfile.user = value;
            LoggedUser.data = value;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => UserProfile()),
                (route) => false);
          }
        });
        break;
      default:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomePage.fromBase64(globalJWT)),
            (route) => false);
        break;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
          child: GNav(
              gap: 2,
              activeColor: Colors.green,
              iconSize: 26,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              duration: Duration(milliseconds: 700),
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Početna',
                  iconColor: Colors.grey,
                ),
                GButton(
                  icon: LineIcons.bell,
                  text: 'Obaveštenja',
                  iconColor: Colors.grey,
                ),
                GButton(
                  icon: LineIcons.plus,
                  text: 'Nova objava',
                  iconColor: Colors.grey,
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Pretražite',
                  iconColor: Colors.grey,
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profil',
                  iconColor: Colors.grey,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                if (!mounted) return;
                setState(() {
                  callPage(index);
                });
              }),
        ),
      ),
    );
  }
}

class GNav extends StatefulWidget {
  GNav({
    Key key,
    this.tabs,
    this.selectedIndex = 0,
    this.onTabChange,
    this.gap,
    this.padding,
    this.activeColor,
    this.color,
    this.backgroundColor,
    this.tabBackgroundColor,
    this.iconSize,
    this.textStyle,
    this.curve,
    this.tabMargin,
    this.debug,
    this.duration,
    this.tabBackgroundGradient,
  });

  final List<GButton> tabs;
  final int selectedIndex;
  final Function onTabChange;
  final double gap;
  final double iconSize;
  final Color activeColor;
  final Color backgroundColor;
  final Color tabBackgroundColor;
  final Color color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry tabMargin;
  final TextStyle textStyle;
  final Duration duration;
  final Curve curve;
  final bool debug;
  final Gradient tabBackgroundGradient;

  @override
  _GNavState createState() => _GNavState();
}

class _GNavState extends State<GNav> {
  int selectedIndex;
  bool clickable = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedIndex = widget.selectedIndex;

    return Container(
        color: widget.backgroundColor ?? Colors.transparent,
        // padding: EdgeInsets.all(12),
        // alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.tabs
                .map((t) => GButton(
                      debug: widget.debug ?? false,
                      margin: t.margin ?? widget.tabMargin,
                      active: selectedIndex == widget.tabs.indexOf(t),
                      gap: t.gap ?? widget.gap,
                      iconActiveColor: t.iconActiveColor ?? widget.activeColor,
                      iconColor: t.iconColor ?? widget.color,
                      iconSize: t.iconSize ?? widget.iconSize,
                      textColor: t.textColor ?? widget.activeColor,
                      padding: t.padding ?? widget.padding,
                      textStyle: t.textStyle ?? widget.textStyle,
                      text: t.text,
                      icon: t.icon,
                      curve: widget.curve ?? Curves.ease,
                      backgroundGradient:
                          t.backgroundGradient ?? widget.tabBackgroundGradient,
                      backgroundColor: t.backgroundColor ??
                          widget.tabBackgroundColor ??
                          Colors.transparent,
                      duration: widget.duration ?? Duration(milliseconds: 500),
                      onPressed: () {
                        if (!clickable) return;
                        if (!mounted) return;
                        setState(() {
                          selectedIndex = widget.tabs.indexOf(t);
                          clickable = false;
                        });
                        widget.onTabChange(selectedIndex);

                        Future.delayed(
                            widget.duration ?? Duration(milliseconds: 500), () {
                          if (!mounted) return;
                          setState(() {
                            clickable = true;
                          });
                        });
                      },
                    ))
                .toList()));
  }
}

class GButton extends StatefulWidget {
  final bool active;
  final bool debug;
  final double gap;
  final Color iconColor;
  final Color iconActiveColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle textStyle;
  final double iconSize;
  final Function onPressed;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Duration duration;
  final Curve curve;
  final Gradient backgroundGradient;

  GButton({
    Key key,
    this.active,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.iconActiveColor,
    this.text,
    this.textColor,
    this.padding,
    this.margin,
    this.duration,
    this.debug,
    this.gap,
    this.curve,
    this.textStyle,
    this.iconSize,
    this.onPressed,
    this.backgroundGradient,
  });

  @override
  _GButtonState createState() => _GButtonState();
}

class _GButtonState extends State<GButton> {
  @override
  Widget build(BuildContext context) {
    return Button(
      debug: widget.debug,
      duration: widget.duration,
      iconSize: widget.iconSize,
      active: widget.active,
      onPressed: () {
        widget.onPressed();
      },
      padding: widget.padding,
      margin: widget.margin,
      gap: widget.gap,
      color: widget.backgroundColor,
      gradient: widget.backgroundGradient,
      curve: widget.curve,
      icon: Icon(widget.icon,
          color: widget.active ? widget.iconActiveColor : widget.iconColor,
          size: widget.iconSize),
      text: Text(
        widget.text,
        style: widget.textStyle ??
            TextStyle(fontWeight: FontWeight.w600, color: widget.textColor),
      ),
    );
  }
}

class Button extends StatefulWidget {
  Button({
    Key key,
    this.icon,
    this.iconSize,
    this.text,
    this.gap = 0,
    this.color,
    this.onPressed,
    this.duration,
    this.curve,
    this.padding = const EdgeInsets.all(25),
    this.margin = const EdgeInsets.all(0),
    this.active = false,
    this.debug,
    this.gradient,
  }) : super(key: key);

  final Widget icon;
  final double iconSize;
  final Widget text;
  final Color color;
  final double gap;
  final bool active;
  final bool debug;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Duration duration;
  final Curve curve;
  final Gradient gradient;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  bool _expanded;

  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _expanded = widget.active;

    expandController =
        AnimationController(vsync: this, duration: widget.duration);
    animation = CurvedAnimation(
        parent: expandController,
        curve: widget.curve,
        reverseCurve: widget.curve.flipped
        // curve: Cubic(0.25, 1.03, 0.31, 0.92),
        // reverseCurve: Cubic(0.77, 0.67, 0, 10).flipped

        );
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _expanded = !widget.active;
    if (_expanded)
      expandController.reverse();
    else
      expandController.forward();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        color:
            widget.gradient != null ? null : widget.debug ? Colors.red : null,
        padding: widget.margin,
        child: AnimatedContainer(
          // padding: EdgeInsets.symmetric(horizontal: 5),
          padding: widget.padding,
          // curve: Curves.easeOutQuad,
          duration: Duration(
              milliseconds:
                  (widget.duration.inMilliseconds.toInt() / 2).round()),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            color: _expanded
                ? widget.color.withOpacity(0)
                : widget.gradient != null ? Colors.white : widget.color,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: Stack(overflow: Overflow.visible, children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.padding.vertical / 2),
                  child: widget.icon,
                ),
              ],
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                      height: widget.iconSize + widget.padding.vertical,
                      width: 0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizeTransition(
                        axis: Axis.horizontal,
                        axisAlignment: 1,
                        sizeFactor: animation,
                        child: AnimatedOpacity(
                          opacity: _expanded ? 0.0 : 1.0,
                          curve: _expanded
                              ? Curves.easeOutQuint
                              : Curves.easeInQuad,
                          duration: Duration(
                              milliseconds:
                                  (widget.duration.inMilliseconds.toInt() / 1.5)
                                      .round()),
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: widget.gap + widget.iconSize),
                              alignment: Alignment.centerRight,
                              child: widget.text),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: widget.padding.vertical / 2),
                              child: widget.icon),
                          SizeTransition(
                            axis: Axis.horizontal,
                            axisAlignment: 1,
                            sizeFactor: animation,
                            child: Opacity(
                              opacity: 0, // debug use
                              child: Container(
                                  color: Colors.red.withOpacity(.2),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.gap),
                                  child: widget.text),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
