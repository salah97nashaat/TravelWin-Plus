class Tickets {
  Tickets({
    this.id,
    this.ticketNumber,});

  Tickets.fromJson(dynamic json) {
    id = json['id'];
    ticketNumber = json['ticket_number'];
  }
  int? id;
  String? ticketNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['ticket_number'] = ticketNumber;
    return map;
  }

}
class Ticket {
  Ticket({
      this.status, 
      this.tickets,});

  Ticket.fromJson(dynamic json) {
    status = json['status'];
    if (json['tickets'] != null) {
      tickets = [];
      json['tickets'].forEach((v) {
        tickets!.add(Tickets.fromJson(v));
      });
    }
  }
  bool? status;
  List<Tickets>? tickets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (tickets != null) {
      map['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}