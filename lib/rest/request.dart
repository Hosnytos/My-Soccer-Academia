import 'dart:convert';
import 'package:http/http.dart' as http;

const rapidApiUrl = "api-football-v1.p.rapidapi.com";
const api_key = "ca98d798bamshd0e88a8da3efd43p17a0b1jsn62feebbccdac";
final Map<String, String> _headers = {
  "content-type": "application/json",
  "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
  "x-rapidapi-key": api_key,
};

enum RequestType {
  get,
  put,
  post,
  delete
}

Future<DataList> fetchGetDataList(RequestType type, String route,
    Map<String, String> queryParams) async {
  http.Response response;

  if(queryParams == null){
    queryParams = new Map();
  }
  queryParams[''] = '{}';
  var completeUrl = Uri.https(rapidApiUrl, route, queryParams);


  switch (type) {
    case RequestType.get:
      response = await http.get(completeUrl, headers: _headers);
      break;
    case RequestType.post:
      response = await http.post(completeUrl);
      break;
    case RequestType.put:
      response = await http.put(completeUrl);
      break;
    case RequestType.delete:
      response = await http.delete(completeUrl);
      break;
  }

  if (response.statusCode == 201) {
    return DataList.fromJson(json.decode(response.body), response.toString(), response.statusCode);
  }
  else if(response.statusCode == 200){
    List responseBody = json.decode(response.body)['response'];
    return DataList.fromJson(responseBody, response.toString(), response.statusCode);
  }
  else {
    return DataList.fromJson([0], response.body, response.statusCode);
  }
}

class DataList {
  final List body;
  final int status;
  final String reason;

  DataList({required this.body, required this.reason, required this.status});

  factory DataList.fromJson(List body, String reason, int status) {
    return DataList(
        body:body,
        status:status,
        reason:reason
    );
  }
}


Future<DataMap> fetchGetDataMap(RequestType type, String route, Map<String, String> queryParams) async {
  http.Response response;

  if(queryParams == null){
    queryParams = new Map();
  }
  queryParams[''] = '{}';
  var completeUrl = Uri.https(rapidApiUrl, route, queryParams);


  switch (type) {
    case RequestType.get:
      response = await http.get(completeUrl, headers: _headers);
      break;
    case RequestType.post:
      response = await http.post(completeUrl);
      break;
    case RequestType.put:
      response = await http.put(completeUrl);
      break;
    case RequestType.delete:
      response = await http.delete(completeUrl);
      break;
  }

  if (response.statusCode == 201) {
    return DataMap.fromJson(json.decode(response.body), response.toString(), response.statusCode);
  }
  else if(response.statusCode == 200){
    return DataMap.fromJson(json.decode(response.body), response.toString(), response.statusCode);
  }
  else {
    return DataMap.fromJson({"":""}, response.body, response.statusCode);
  }
}

class DataMap {
  final Map<String, dynamic> body;
  final int status;
  final String reason;

  DataMap({required this.body, required this.reason, required this.status});

  factory DataMap.fromJson(Map<String, dynamic> body, String reason, int status) {
    return DataMap(
        body:body,
        status:status,
        reason:reason
    );
  }
}