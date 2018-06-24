import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:hillelcoren/data/models/entities.dart';

part 'stub_model.g.dart';

abstract class StubListResponse implements Built<StubListResponse, StubListResponseBuilder> {

  BuiltList<StubEntity> get data;

  StubListResponse._();
  factory StubListResponse([updates(StubListResponseBuilder b)]) = _$StubListResponse;
  static Serializer<StubListResponse> get serializer => _$stubListResponseSerializer;
}

abstract class StubItemResponse implements Built<StubItemResponse, StubItemResponseBuilder> {

  StubEntity get data;

  StubItemResponse._();
  factory StubItemResponse([updates(StubItemResponseBuilder b)]) = _$StubItemResponse;
  static Serializer<StubItemResponse> get serializer => _$stubItemResponseSerializer;
}

class StubFields {

}

abstract class StubEntity extends Object with BaseEntity implements Built<StubEntity, StubEntityBuilder> {

  static int counter = 0;
  factory StubEntity() {
    return _$StubEntity._(
    );
  }

  int compareTo(StubEntity stub, String sortField, bool sortAscending) {
    int response = 0;
    StubEntity stubA = sortAscending ? this : stub;
    StubEntity stubB = sortAscending ? stub: this; 

    switch (sortField) {
      // TODO case StubFields.taskRate:
      //  response = stubA.taskRate.compareTo(stubB.taskRate);
    }

    if (response == 0) {
      // TODO return stubA.name.compareTo(stubB.name);
    } else {
      return response;
    }
  }

  bool matchesSearch(String search) {
    if (search == null || search.isEmpty) {
      return true;
    }

    // TODO return name.contains(search);
  }

  StubEntity._();
  static Serializer<StubEntity> get serializer => _$stubEntitySerializer;
}
