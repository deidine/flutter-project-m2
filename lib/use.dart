import 'package:flutter/material.dart';


class TransferItem extends StatelessWidget {
  final Transfer transfer;
  final int teamId;
  TransferItem(this.transfer, this.teamId);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Material(
        color: Colors.white,
        elevation: 10,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(transfer.playerName!,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: transfer.teamIn?.teamId == teamId
                          ? Colors.green
                          : Colors.red)),
              if (transfer.type != null)
                Text(transfer.type!,
                    style: TextStyle(
                      fontSize: 20,
                    )),
              SizedBox(height: 5),
              if (transfer.transferDate != null)
                Text(transfer.transferDate!,
                    style: TextStyle(fontSize: 23, color: Colors.black)),
// Flag:  https://media.api-football.com/teams/541.png
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.network(
                    'https://media.api-football.com/teams/${transfer.teamIn?.teamId}.png',
                    height: 95,
                    fit: BoxFit.fitHeight,
                  ),
                  Icon(
                    Icons.arrow_left,
                    size: 50,
                    color: transfer.teamIn?.teamId == teamId
                        ? Colors.green
                        : Colors.red,
                  ),
                  Image.network(
                    'https://media.api-football.com/teams/${transfer.teamOut!.teamId}.png',
                    height: 95,
                    fit: BoxFit.fitHeight,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}class Transfer {
  int playerId;
  String playerName;
  String transferDate;
  String type;
  TeamIn teamIn;
  TeamIn teamOut;
  int lastUpdate;

  Transfer(
      {this.playerId,
      this.playerName,
      this.transferDate,
      this.type,
      this.teamIn,
      this.teamOut,
      this.lastUpdate});

  Transfer.fromJson(Map<String, dynamic> json) {
    playerId = json['player_id'];
    playerName = json['player_name'];
    transferDate = json['transfer_date'];
    type = json['type'];
    teamIn =
        json['team_in'] != null ? new TeamIn.fromJson(json['team_in']) : null;
    teamOut =
        json['team_out'] != null ? new TeamIn.fromJson(json['team_out']) : null;
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['player_id'] = this.playerId;
    data['player_name'] = this.playerName;
    data['transfer_date'] = this.transferDate;
    data['type'] = this.type;
    if (this.teamIn != null) {
      data['team_in'] = this.teamIn.toJson();
    }
    if (this.teamOut != null) {
      data['team_out'] = this.teamOut.toJson();
    }
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}

class TeamIn {
  int teamId;
  String teamName;

  TeamIn({required this.teamId,required  this.teamName});

  TeamIn.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'];
    teamName = json['team_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_id'] = this.teamId;
    data['team_name'] = this.teamName;
    return data;
  }
}
