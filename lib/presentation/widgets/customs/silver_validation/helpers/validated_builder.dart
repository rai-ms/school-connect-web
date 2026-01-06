import 'package:flutter/material.dart';
import 'package:async/async.dart';
import '../silver_validation.dart';

class ValidatedBuilder extends StatefulWidget {
  const ValidatedBuilder({
    required this.validations,
    required this.builder,
    super.key,
  });

  final List<BaseValidator> validations;
  final Widget Function(
    BuildContext context,
    bool? isValidated,
    bool Function() validate,
    List<BaseValidator> validations,
  ) builder;

  @override
  State<ValidatedBuilder> createState() => _ValidatedBuilderState();
}

class _ValidatedBuilderState extends State<ValidatedBuilder> {
  late final StreamGroup<ValidatorError> _errorStream;

  bool get noValidation => widget.validations.isEmpty;
  bool get singleValidation => widget.validations.length == 1;
  bool get multipleValidation => widget.validations.length > 1;

  @override
  void initState() {
    super.initState();
    _errorStream = StreamGroup();
    addNew(widget);
  }

  @override
  void didUpdateWidget(covariant ValidatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    removeOld(oldWidget);
    addNew(widget);
  }

  void addNew(ValidatedBuilder widget) {
    for (var controller in widget.validations) {
      _errorStream.add(controller.errorDataStream);
    }
  }

  void removeOld(ValidatedBuilder oldWidget) {
    for (var oldController in oldWidget.validations) {
      _errorStream.remove(oldController.errorDataStream);
    }
  }

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (noValidation) {
      return widget.builder(context, null, () => true, widget.validations);
    } else {
      return StreamBuilder<ValidatorError>(
          initialData: const ValidatorError.empty(),
          stream: _errorStream.stream,
          builder: (context, snapshot) {
            var validation = widget.validations.every(
              (controller) => controller.error.isCorrect,
            );
            bool validate() {
              bool isValidated = true;
              for (var controller in widget.validations) {
                ValidatorError error;
                if (controller is ValidatedController) {
                  error = controller.validate(const ActiveValidation());
                } else {
                  error = controller.validate();
                }

                if (!error.isCorrect) isValidated = false;
              }

              return isValidated;
            }

            return widget.builder(
              context,
              validation,
              validate,
              widget.validations,
            );
          }
        );
    }
  }
}
