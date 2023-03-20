class message_model{
  String? _text;
  String? _sender;

  message_model(this._text, this._sender);

  String get sender => _sender!;

  set sender(String value) {
    _sender = value;
  }

  String get text => _text!;

  set text(String value) {
    _text = value;
  }
}