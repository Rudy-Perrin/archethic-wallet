/// SPDX-License-Identifier: AGPL-3.0-or-later

// Package imports:
import 'package:core/model/data/contact.dart';
import 'package:event_taxi/event_taxi.dart';

class ContactModifiedEvent implements Event {
  ContactModifiedEvent({this.contact});

  final Contact? contact;
}
