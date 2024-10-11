// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Init _$InitFromJson(Map<String, dynamic> json) => Init(
      accessToken: json['access_token'] == null
          ? null
          : AccessToken.fromJson(json['access_token'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      businessProfile: json['business_profile'] == null
          ? null
          : Profile.fromJson(json['business_profile'] as Map<String, dynamic>),
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      initData: json['init_data'] == null
          ? null
          : InitData.fromJson(json['init_data'] as Map<String, dynamic>),
      inventory: (json['inventories'] as List<dynamic>?)
          ?.map((e) => Inventory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InitToJson(Init instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'profile': instance.profile,
      'business_profile': instance.businessProfile,
      'country': instance.country,
      'role': instance.role,
      'init_data': instance.initData,
      'inventories': instance.inventory,
    };

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) => AccessToken(
      accessToken: json['access_token'] as String?,
      expiresIn: json['expires_in'] as int?,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String?,
    );

Map<String, dynamic> _$AccessTokenToJson(AccessToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      realm: json['realm'] as String?,
      id: json['id'] as String?,
      emailDeflt: json['email_deflt'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      businessName: json['business_name'] as String?,
      alias: json['alias'] as String?,
      country: json['country'] as String?,
      lock: json['lock'] as bool?,
      idDoc: json['id_doc'] as String?,
      idDocType: json['id_doc_type'] as String?,
      type: json['type'] as String?,
      phoneDeflt: json['phone_deflt'] as String?,
      bankAccounts: json['bank_accounts'] as List<dynamic>?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'realm': instance.realm,
      'id': instance.id,
      'email_deflt': instance.emailDeflt,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'business_name': instance.businessName,
      'alias': instance.alias,
      'country': instance.country,
      'lock': instance.lock,
      'id_doc': instance.idDoc,
      'id_doc_type': instance.idDocType,
      'type': instance.type,
      'phone_deflt': instance.phoneDeflt,
      'bank_accounts': instance.bankAccounts,
    };

Capital _$CapitalFromJson(Map<String, dynamic> json) => Capital(
      name: json['name'] as String?,
      municipalities: json['municipalities'] as List<dynamic>?,
      cities: json['cities'] as List<dynamic>?,
    );

Map<String, dynamic> _$CapitalToJson(Capital instance) => <String, dynamic>{
      'name': instance.name,
      'municipalities': instance.municipalities,
      'cities': instance.cities,
    };

States _$StatesFromJson(Map<String, dynamic> json) => States(
      name: json['name'] as String?,
      municipalities: json['municipalities'] as List<dynamic>?,
      cities: json['cities'] as List<dynamic>?,
    );

Map<String, dynamic> _$StatesToJson(States instance) => <String, dynamic>{
      'name': instance.name,
      'municipalities': instance.municipalities,
      'cities': instance.cities,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      createdBy: json['created_by'] as String?,
      createdByEmail: json['created_by_email'] as String?,
      createdAt: json['created_at'] as String?,
      updatedBy: json['updated_by'] as String?,
      updatedByEmail: json['updated_by_email'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'created_by': instance.createdBy,
      'created_by_email': instance.createdByEmail,
      'created_at': instance.createdAt,
      'updated_by': instance.updatedBy,
      'updated_by_email': instance.updatedByEmail,
      'updated_at': instance.updatedAt,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      realm: json['realm'] as String?,
      alpha2: json['alpha2'] as String?,
      alpha3: json['alpha3'] as String?,
      isoNumber: json['iso_number'] as String?,
      name: json['name'] as String?,
      shortName: json['short_name'] as String?,
      capital: json['capital'] == null
          ? null
          : Capital.fromJson(json['capital'] as Map<String, dynamic>),
      states: (json['states'] as List<dynamic>?)
          ?.map((e) => States.fromJson(e as Map<String, dynamic>))
          .toList(),
      currency: json['currency'] as String?,
      currencies: json['currencies'] as List<dynamic>?,
      info: json['info'] as Map<String,dynamic>?
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'realm': instance.realm,
      'alpha2': instance.alpha2,
      'alpha3': instance.alpha3,
      'iso_number': instance.isoNumber,
      'name': instance.name,
      'short_name': instance.shortName,
      'capital': instance.capital,
      'states': instance.states,
      'currency': instance.currency,
      'currencies': instance.currencies,
      'info': instance.info,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      businessId: json['business_id'] as String?,
      userId: json['user_id'] as String?,
      appName: json['app_name'] as String?,
      appStatus: json['app_status'] as String?,
      appUrl: json['app_url'] as String?,
      appIcon: json['app_icon'] as String?,
      scopeName: json['scope_name'] as String?,
      scopeId: json['scope_id'] as String?,
      ownerName: json['owner_name'] as String?,
      ownerEmail: json['owner_email'] as String?,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      thirdPartyAuthorization: json['third_party_authorization'] as bool?,
      realm: json['realm'] as String?,
      name: json['name'] as String?,
      views: (json['views'] as List<dynamic>?)
          ?.map((e) => View.fromJson(e as Map<String, dynamic>))
          .toList(),
      scopes: json['scopes'] as List<dynamic>?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'realm': instance.realm,
      'business_id': instance.businessId,
      'user_id': instance.userId,
      'app_name': instance.appName,
      'app_status': instance.appStatus,
      'app_url': instance.appUrl,
      'app_icon': instance.appIcon,
      'scope_name': instance.scopeName,
      'scope_id': instance.scopeId,
      'name': instance.name,
      'owner_name': instance.ownerName,
      'owner_email': instance.ownerEmail,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'third_party_authorization': instance.thirdPartyAuthorization,
      'views': instance.views,
      'scopes': instance.scopes,
    };

View _$ViewFromJson(Map<String, dynamic> json) => View(
      name: json['name'] as String?,
      functionality: json['functionality'] as String?,
      url: json['url'] as String?,
      type: json['type'] as String?,
      icon: json['icon'] as String?,
      tag: json['tag'] as String?,
      sort: json['sort'] as int?,
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => Action.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ViewToJson(View instance) => <String, dynamic>{
      'name': instance.name,
      'functionality': instance.functionality,
      'url': instance.url,
      'type': instance.type,
      'icon': instance.icon,
      'tag': instance.tag,
      'sort': instance.sort,
      'actions': instance.actions,
    };

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
      name: json['name'] as String?,
      sort: json['sort'] as int?,
      functionalityDetail: json['functionality_detail'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      functionName: json['function_name'] as String?,
      scopes: json['scopes'] as List<dynamic>?,
    );

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'name': instance.name,
      'sort': instance.sort,
      'functionality_detail': instance.functionalityDetail,
      'type': instance.type,
      'status': instance.status,
      'function_name': instance.functionName,
      'scopes': instance.scopes,
    };

InitData _$InitDataFromJson(Map<String, dynamic> json) => InitData(
      inventories: (json['inventories'] as List<dynamic>?)
          ?.map((e) => Inventory.fromJson(e as Map<String, dynamic>))
          .toList(),
      ally: json['ally'] == null
          ? null
          : Ally.fromJson(json['ally'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitDataToJson(InitData instance) => <String, dynamic>{
      'inventories': instance.inventories,
      'ally': instance.ally,
    };

Ally _$AllyFromJson(Map<String, dynamic> json) => Ally(
      realm: json['realm'] as String?,
      businessId: json['business_id'] as String?,
      id: json['id'] as String?,
      businessName: json['business_name'] as String?,
      businessEmail: json['business_email'] as String?,
      businessIdDoc: json['business_id_doc'] as String?,
      businessIdDocType: json['business_id_doc_type'] as String?,
      allyName: json['ally_name'] as String?,
      allyEmail: json['ally_email'] as String?,
      allyIdDoc: json['ally_id_doc'] as String?,
      allyIdDocType: json['ally_id_doc_type'] as String?,
      status: json['status'] as String?,
      paymentMethods: (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AllyToJson(Ally instance) => <String, dynamic>{
      'realm': instance.realm,
      'business_id': instance.businessId,
      'id': instance.id,
      'business_name': instance.businessName,
      'business_email': instance.businessEmail,
      'business_id_doc': instance.businessIdDoc,
      'business_id_doc_type': instance.businessIdDocType,
      'ally_name': instance.allyName,
      'ally_email': instance.allyEmail,
      'ally_id_doc': instance.allyIdDoc,
      'ally_id_doc_type': instance.allyIdDocType,
      'status': instance.status,
      'payment_methods': instance.paymentMethods,
    };

Inventory _$InventoryFromJson(Map<String, dynamic> json) => Inventory(
      realm: json['realm'] as String?,
      businessId: json['business_id'] as String?,
      type: json['type'] as String?,
      id: json['id'] as String?,
      businessName: json['business_name'] as String?,
      businessEmail: json['business_email'] as String?,
      idDoc: json['id_doc'] as String?,
      idDocType: json['id_doc_type'] as String?,
      allyStatus: json['ally_status'] as String?,
      name: json['name'] as String?,
      unit: json['unit'] as String?,
      balance: json['balance'],
      minLimit: json['min_limit'] as int?,
      transactionFee: json['transaction_fee'] as int?,
      feeChargeType: json['fee_charge_type'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'realm': instance.realm,
      'business_id': instance.businessId,
      'type': instance.type,
      'id': instance.id,
      'business_name': instance.businessName,
      'business_email': instance.businessEmail,
      'id_doc': instance.idDoc,
      'id_doc_type': instance.idDocType,
      'ally_status': instance.allyStatus,
      'name': instance.name,
      'unit': instance.unit,
      'balance': instance.balance,
      'min_limit': instance.minLimit,
      'transaction_fee': instance.transactionFee,
      'fee_charge_type': instance.feeChargeType,
      'products': instance.products,
    };
