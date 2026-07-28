import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_tokens.dart';

/// Standard custom styled TextFormField wrapping M3 decoration styles.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.inputFormatters,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Text input specialized for password fields. Manages obscure toggle state.
class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  const PasswordField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.validator,
    this.textInputAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      obscureText: _obscureText,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: const Icon(Icons.lock_outline, size: AppDesignTokens.iconMD),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: AppDesignTokens.iconMD,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      ),
    );
  }
}

/// Text input preconfigured for email entry and validators.
class EmailField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  const EmailField({
    super.key,
    this.controller,
    this.validator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: 'Email Address',
      hintText: 'name@example.com',
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      textInputAction: textInputAction,
      prefixIcon: const Icon(
        Icons.email_outlined,
        size: AppDesignTokens.iconMD,
      ),
    );
  }
}

/// Text input configured for numerical currency amounts.
class AmountField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final String currencySymbol;

  const AmountField({
    super.key,
    this.controller,
    this.validator,
    this.textInputAction,
    this.currencySymbol = r'$',
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: 'Amount',
      hintText: '0.00',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      prefixIcon: Padding(
        padding: const EdgeInsets.all(AppDesignTokens.spaceMD),
        child: Text(
          currencySymbol,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}

/// Search field input with built-in clear button and search indicators.
class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      prefixIcon: const Icon(Icons.search, size: AppDesignTokens.iconMD),
      suffixIcon: controller != null && controller!.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear, size: AppDesignTokens.iconMD),
              onPressed: () {
                controller!.clear();
                if (onClear != null) onClear!();
              },
              tooltip: 'Clear search',
            )
          : null,
    );
  }
}

/// Input field spanning multiple lines, configured for notes or descriptions.
class MultilineField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final int minLines;
  final FormFieldValidator<String>? validator;

  const MultilineField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.minLines = 3,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      minLines: minLines,
      maxLines: null, // Allow auto expansion vertically
      keyboardType: TextInputType.multiline,
      validator: validator,
    );
  }
}
