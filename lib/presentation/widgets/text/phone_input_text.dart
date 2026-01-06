import 'dart:convert';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PhoneInputField extends StatefulWidget {
  final Function(String, String, String) callBackFunction;

  bool isInit;
  final Color? color;
  PhoneInputField({
    super.key,
    this.color,
    required this.callBackFunction,
    this.isInit = true,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  List<CountryModel> countryList = [];
  CountryModel? selectedCountryData;

  @override
  void didChangeDependencies() async {
    if (widget.isInit) {
      widget.isInit = false;
      final data = await DefaultAssetBundle.of(context)
          .loadString('assets/countrycode.json');
      setState(() {
        countryList = parseJson(data);
        selectedCountryData = countryList[0];
      });
      widget.callBackFunction(selectedCountryData!.name,
          selectedCountryData!.dialCode, selectedCountryData!.flag);
    }
    super.didChangeDependencies();
  }

  List<CountryModel> parseJson(String response) {
    // ignore: unnecessary_null_comparison
    if (response == null) {
      return [];
    }
    final parsed =
    json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<CountryModel>(
            (json) => CountryModel.fromJson(json as Map<String, dynamic>))
        .toList() as List<CountryModel>;
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 10,
      child: TextFormField(
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          border: InputBorder.none,
          filled: false,
          hintText: 'Enter phone number',
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF00BAAB)),
          ),
          prefixIcon: Container(
            height: 45,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: _isFocused ? const Color(0xFF00BAAB) : null,
                borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(10))),
            child: InkResponse(
              onTap: () {
                showDialogue(context);
              },
              child: SizedBox(
                width: 90,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectedCountryData != null
                          ? selectedCountryData!.flag
                          : '',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      selectedCountryData != null
                          ? selectedCountryData!.dialCode
                          : '',
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF5E5E5E)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDialogue(BuildContext context) async {
    final countryData = await showDialog(
      context: context,
      builder: (BuildContext context) => CountryPickerDialog(
        searchList: countryList,
        callBackFunction: widget.callBackFunction,
      ),
    );
    if (mounted && countryData != null) {
      selectedCountryData = countryData as CountryModel;
      setState(() {});
    }
  }
}

class CountryModel {
  const CountryModel(
      {required this.name,
        required this.dialCode,
        required this.code,
        required this.flag});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final flag = CountryModel.getEmojiFlag(json['code'] as String);
    return CountryModel(
        name: json['name'] as String,
        dialCode: json['dial_code'] as String,
        code: json['code'] as String,
        flag: flag);
  }

  final String name, dialCode, code, flag;

  static String getEmojiFlag(String emojiString) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;
    final firstChar = emojiString.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = emojiString.codeUnitAt(1) - asciiOffset + flagOffset;
    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}

class CountryPickerDialog extends StatefulWidget {
  final List<CountryModel> searchList;
  final Function callBackFunction;

  const CountryPickerDialog({
    super.key,
    required this.searchList,
    required this.callBackFunction,
  });

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  List<CountryModel> tmpList = [];

  Widget dialogContent(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Color(0xFF222222),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Select Country',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkResponse(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search Country',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18.0,
                    color: Colors.black38,
                  )),
              onChanged: filterData,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...tmpList.map(
                        (item) => GestureDetector(
                      onTap: () {
                        Navigator.pop(context, item);
                        widget.callBackFunction(
                            item.name, item.dialCode, item.flag);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.flag,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              item.dialCode,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void filterData(String text) {
    tmpList = [];
    if (text == '') {
      tmpList.addAll(widget.searchList);
    } else {
      for (var userDetail in widget.searchList) {
        if (userDetail.name.toLowerCase().contains(text.toLowerCase())) {
          tmpList.add(userDetail);
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tmpList = widget.searchList;
  }

  // build method
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF1E1E1E),
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
      child: child,
    );
  }
}
