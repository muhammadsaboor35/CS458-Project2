import 'package:flutter/material.dart';
import 'package:vaccine_survey/widgets/custom_button.dart';
import 'package:vaccine_survey/widgets/ensure_visible_when_focused.dart';
import 'package:vaccine_survey/widgets/spacer.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Covid-19 Vaccine Survey",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Covid-19 Vaccine Survey"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _dialogKey = GlobalKey();

  ScrollController _scrollController;

  final FocusNode _nameSurnameFocus = FocusNode();
  final FocusNode _birthDateFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _vaccineTypeFocus = FocusNode();
  final FocusNode _sideEffectFocus = FocusNode();

  TextEditingController nameSurnameController;
  TextEditingController birthDateController;
  TextEditingController cityController;
  TextEditingController sideEffectController;

  List<String> _genders = [];
  List<DropdownMenuItem<int>> _genderItems = [];
  int _selectedGender = 0;

  List<String> _vaccineTypes = [];
  List<DropdownMenuItem<int>> _vaccineTypeItems = [];
  int _selectedVaccineType = 0;

  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController();

    nameSurnameController = TextEditingController(text: "");
    birthDateController = TextEditingController(text: "");
    cityController = TextEditingController(text: "");
    sideEffectController = TextEditingController(text: "");

    initDropdown();
  }

  initDropdown() {
    _vaccineTypes = [
      "Pfizer-BioNTech",
      "Moderna",
      "Johnson & Johnson / Janssen",
    ];

    _vaccineTypes.insert(0, "Select Vaccine Type");
    _vaccineTypeItems = List.generate(_vaccineTypes.length, ((index) {
      return DropdownMenuItem(
        value: index,
        child: Text(_vaccineTypes[index]),
      );
    }));
    _selectedVaccineType = 0;

    _genders = [
      "Female",
      "Male",
      "Do not wish to specify",
    ];

    _genders.insert(0, "Select Gender");
    _genderItems = List.generate(_genders.length, ((index) {
      return DropdownMenuItem(
        value: index,
        child: Text(_genders[index]),
      );
    }));
    _selectedGender = 0;
  }

  String _validateNameSurname(String value) {
    value = value.trim();
    if (value.isEmpty)
      return "Name-Surname is required!";
    else
      return null;
  }

  String _validateBirthDate(String value) {
    if (value.isEmpty)
      return "Birth date is required!";
    else
      return null;
  }

  String _validateCity(String value) {
    if (value.isEmpty)
      return "City is required!";
    else
      return null;
  }

  String _validateGender(int value) {
    if (value == 0)
      return "Gender is required!";
    else
      return null;
  }

  String _validateVaccineType(int value) {
    if (value == 0)
      return "Vaccine type is required!";
    else
      return null;
  }

  String _validateSideEffect(String value) {
//    if (value.isEmpty)
//      return "Side effect is required!";
//    else
    return null;
  }

  void _fieldFocusChange(context, currentNode, nextFocus) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _showDatePicker() {
    DateTime now = DateTime.now();

    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenAwareSize(10, context),
//              vertical: screenAwareSize(30, context),
            ),
            child: child,
          );
        }).then((date) {
      if (date != null) {
        if (DateTime.now().isBefore(date)) {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Future date is not allowed!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
        } else {
          _selectedDate = date;
          birthDateController.text = getDate(_selectedDate);
        }
        _fieldFocusChange(
          context,
          _birthDateFocus,
          _cityFocus,
        );
      }
    });
  }

  showSuccessfulMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: _dialogKey,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSpacer(space: screenAwareProportionalHeight(30, context)),
                    Text(
                      "Survey Accepted!\nThanks for attending!",
                      style: TextStyle(
                        fontSize: screenAwareSize(20, context),
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    CustomSpacer(space: screenAwareProportionalHeight(30, context)),
                    CustomButton(
					  key: Key('OKbtn'),
                      width: screenWidthPercent(50, context),
                      onTap: () {
                        _unFocusFields();
                        _resetFields();
                        Navigator.pop(context);
                      },
                      text: "OK",
                      radius: screenAwareSize(15, context),
                    ),
                    CustomSpacer(space: screenAwareProportionalHeight(30, context)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String getDate(DateTime date) {
    String day = date.day < 10 ? "0" + date.day.toString() : date.day.toString();
    String month = date.month < 10 ? "0" + date.month.toString() : date.month.toString();
    String year = date.year.toString();

    return "$day/$month/$year";
  }

  double screenAwareSize(double size, BuildContext context) {
    return (size * 1.143) * (MediaQuery.of(context).size.width / 375);
  }

  double screenAwareProportionalHeight(double size, BuildContext context) {
    return size * MediaQuery.of(context).size.height / 667;
  }

  void _sendSurvey() {
//    showSuccessfulMessage();
    if (_formKey.currentState.validate()) {
      _unFocusFields();
      showSuccessfulMessage();
    }
  }

  void _resetFields() {
    nameSurnameController = TextEditingController(text: "");
    birthDateController = TextEditingController(text: "");
    _selectedDate = null;
    cityController = TextEditingController(text: "");
    _selectedGender = 0;
    _selectedVaccineType = 0;
    sideEffectController = TextEditingController(text: "");
  }

  bool _validateFields() {
    if (nameSurnameController.text.trim().isNotEmpty &&
        _selectedDate != null &&
        cityController.text.trim().isNotEmpty &&
        _selectedGender != 0 &&
        _selectedVaccineType != 0) return true;
    return false;
  }

  void _unFocusFields() {
    if (_nameSurnameFocus.hasFocus) _nameSurnameFocus.unfocus();
    if (_birthDateFocus.hasFocus) _birthDateFocus.unfocus();
    if (_cityFocus.hasFocus) _cityFocus.unfocus();
    if (_genderFocus.hasFocus) _genderFocus.unfocus();
    if (_vaccineTypeFocus.hasFocus) _vaccineTypeFocus.unfocus();
    if (_sideEffectFocus.hasFocus) _sideEffectFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CustomSpacer(
                        space: screenAwareProportionalHeight(30, context),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _nameSurnameFocus,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenAwareSize(15, context)),
                          child: TextFormField(
                            key: Key('nameSurname'),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              errorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                              focusedErrorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenAwareSize(10, context),
                              ),
                              labelText: "Name Surname",
                            ),
                            cursorColor: Colors.blue,
                            controller: nameSurnameController,
                            keyboardType: TextInputType.name,
                            validator: _validateNameSurname,
                            style: TextStyle(fontSize: screenAwareSize(14, context)),
                            textInputAction: TextInputAction.next,
                            focusNode: _nameSurnameFocus,
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                context,
                                _nameSurnameFocus,
                                _birthDateFocus,
                              );
                              _showDatePicker();
                            },
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: screenAwareProportionalHeight(15, context),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _birthDateFocus,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenAwareSize(15, context)),
                          child: TextFormField(
                            key: Key('birthDate'),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              errorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                              focusedErrorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenAwareSize(10, context),
                              ),
                              hintText: "Birth Date",
                            ),
                            controller: birthDateController,
                            validator: _validateBirthDate,
                            keyboardType: TextInputType.datetime,
                            style: TextStyle(fontSize: screenAwareSize(14, context)),
                            textInputAction: TextInputAction.next,
                            focusNode: _birthDateFocus,
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                context,
                                _birthDateFocus,
                                _cityFocus,
                              );
                            },
                            onTap: _showDatePicker,
                            showCursor: false,
                            readOnly: true,
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: screenAwareProportionalHeight(15, context),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _cityFocus,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenAwareSize(15, context)),
                          child: TextFormField(
                            key: Key('city'),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              errorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                              focusedErrorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenAwareSize(10, context),
                              ),
                              labelText: "City",
                            ),
                            cursorColor: Colors.blue,
                            controller: cityController,
                            keyboardType: TextInputType.name,
                            validator: _validateCity,
                            style: TextStyle(fontSize: screenAwareSize(14, context)),
                            textInputAction: TextInputAction.next,
                            focusNode: _cityFocus,
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                context,
                                _cityFocus,
                                _genderFocus,
                              );
                            },
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: screenAwareProportionalHeight(15, context),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _genderFocus,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: screenAwareSize(15, context)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
								key: Key('gender'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue)),
                                  errorBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                  focusedErrorBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenAwareSize(10, context),
                                  ),
                                ),
                                validator: _validateGender,
                                elevation: 8,
                                value: _selectedGender,
                                isExpanded: true,
                                isDense: false,
                                items: _genderItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                  _fieldFocusChange(
                                    context,
                                    _genderFocus,
                                    _vaccineTypeFocus,
                                  );
                                }),
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: screenAwareProportionalHeight(15, context),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _vaccineTypeFocus,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: screenAwareSize(15, context)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
								key: Key('vaccineType'),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red)),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenAwareSize(10, context),
                                    ),
                                    hintText: ""),
                                validator: _validateVaccineType,
                                elevation: 8,
                                value: _selectedVaccineType,
                                isExpanded: true,
                                isDense: false,
                                items: _vaccineTypeItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedVaccineType = value;
                                  });
                                  _fieldFocusChange(
                                    context,
                                    _vaccineTypeFocus,
                                    _sideEffectFocus,
                                  );
                                }),
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: screenAwareProportionalHeight(15, context),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _sideEffectFocus,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: screenAwareSize(15, context)),
                          child: TextFormField(
							key: Key('sideEffect'),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              errorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                              focusedErrorBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenAwareSize(10, context),
                                vertical: screenAwareProportionalHeight(15, context),
                              ),
                              labelText: "Any Side Effects (Optional)",
                            ),
                            cursorColor: Colors.blue,
                            controller: sideEffectController,
                            keyboardType: TextInputType.multiline,
                            validator: _validateSideEffect,
                            style: TextStyle(fontSize: screenAwareSize(14, context)),
                            textInputAction: TextInputAction.send,
                            maxLines: 3,
                            focusNode: _sideEffectFocus,
                            onFieldSubmitted: (val) {
                              _sendSurvey();
                            },
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: screenAwareProportionalHeight(30, context),
                      ),
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: _validateFields()
                              ? Container(
                                  alignment: Alignment.center,
                                  child: CustomButton(
									key: Key('sendBtn'),
                                    width: screenWidthPercent(70, context),
                                    text: "Send",
                                    onTap: () {
                                      _sendSurvey();
                                    },
                                    radius: screenAwareSize(15, context),
                                  ),
                                )
                              : Container()),
                      _validateFields()
                          ? CustomSpacer(
                              space: screenAwareProportionalHeight(30, context),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
