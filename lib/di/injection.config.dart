// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:cliff_pickleball/blocs/device_and_bluetooth/device_and_bluetooth_bloc.dart'
    as _i6;
import 'package:cliff_pickleball/di/injection_module.dart' as _i37;
import 'package:cliff_pickleball/pages/auth_device/auth_device_bloc.dart'
    as _i35;
import 'package:cliff_pickleball/pages/auth_device/auth_device_service.dart'
    as _i31;
import 'package:cliff_pickleball/pages/bluetooth/ble_perms_check.dart' as _i3;
import 'package:cliff_pickleball/pages/bluetooth/bluetooth_scan_bloc.dart'
    as _i26;
import 'package:cliff_pickleball/pages/bluetooth/impl/ble_perms_check_impl.dart'
    as _i4;
import 'package:cliff_pickleball/pages/bluetooth/location_perms_check.dart'
    as _i14;
import 'package:cliff_pickleball/pages/bottom_nav/bottom_nav_bloc.dart' as _i19;
import 'package:cliff_pickleball/pages/cancel_payment/cancel_payment_bloc.dart'
    as _i27;
import 'package:cliff_pickleball/pages/cancel_payment/cancel_payment_service.dart'
    as _i20;
import 'package:cliff_pickleball/pages/login/get_credentials.dart' as _i21;
import 'package:cliff_pickleball/pages/login/login_bloc.dart' as _i33;
import 'package:cliff_pickleball/pages/login/login_service.dart' as _i28;
import 'package:cliff_pickleball/pages/logout/logout_bloc.dart' as _i36;
import 'package:cliff_pickleball/pages/logout/logout_service.dart' as _i34;
import 'package:cliff_pickleball/pages/new_sale/new_sale_bloc.dart' as _i29;
import 'package:cliff_pickleball/pages/new_sale/new_sale_service.dart' as _i22;
import 'package:cliff_pickleball/pages/new_sale/presenter/input_amount_presenter.dart'
    as _i9;
import 'package:cliff_pickleball/pages/new_sale/presenter/input_id_doc_presenter.dart'
    as _i10;
import 'package:cliff_pickleball/pages/new_sale/presenter/input_pin_presenter.dart'
    as _i11;
import 'package:cliff_pickleball/services/cacheService.dart' as _i5;
import 'package:cliff_pickleball/services/get/fingerprint_service.dart' as _i7;
import 'package:cliff_pickleball/services/http/api_services.dart' as _i18;
import 'package:cliff_pickleball/services/http/auth_interceptor.dart' as _i32;
import 'package:cliff_pickleball/services/http/cache_online_provider.dart'
    as _i13;
import 'package:cliff_pickleball/services/http/http_service.dart' as _i8;
import 'package:cliff_pickleball/services/http/is_online_provider.dart' as _i12;
import 'package:cliff_pickleball/services/token_service.dart' as _i30;
import 'package:cliff_pickleball/styles/profile_theme_selector.dart' as _i15;
import 'package:cliff_pickleball/styles/theme_holder.dart' as _i23;
import 'package:cliff_pickleball/styles/theme_loader.dart' as _i16;
import 'package:cliff_pickleball/styles/theme_provider.dart' as _i24;
import 'package:cliff_pickleball/styles/theme_selector.dart' as _i25;
import 'package:cliff_pickleball/utils/tlv_comparator.dart' as _i17;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    gh.factory<_i3.BlePermsCheck>(() => _i4.BlePermsCheckImpl());
    gh.factory<_i5.Cache>(() => _i5.Cache());
    gh.factory<_i6.DeviceAndBluetoothBloc>(
        () => _i6.DeviceAndBluetoothBloc(gh<_i5.Cache>()));
    gh.factory<_i7.FingerprintService>(() => _i7.FingerprintService());
    gh.lazySingleton<_i8.HttpService>(() => injectionModule.httpService);
    gh.factory<_i9.InputAmountPresenter>(() => _i9.InputAmountPresenter());
    gh.factory<_i10.InputIdDocPresenter>(() => _i10.InputIdDocPresenter());
    gh.factory<_i11.InputPinPresenter>(() => _i11.InputPinPresenter());
    gh.factory<_i12.IsOnlineProvider>(
        () => _i13.CacheOnlineProvider(gh<_i5.Cache>()));
    gh.factory<_i14.LocationPermsCheck>(() => _i14.LocationPermsCheck());
    gh.factory<_i15.ProfileThemeSelector>(() => _i15.ProfileThemeSelector());
    gh.factory<_i16.ThemeLoader>(() => _i16.ThemeLoader());
    gh.factory<_i17.TlvComparator>(() => _i17.TlvComparator());
    gh.factory<_i18.ApiServices>(() => _i18.ApiServices(
          gh<_i8.HttpService>(),
          gh<_i12.IsOnlineProvider>(),
        ));
    gh.factory<_i19.BottomNavBloc>(() => _i19.BottomNavBloc(gh<_i5.Cache>()));
    gh.factory<_i20.CancelPaymentService>(() => _i20.CancelPaymentService(
          gh<_i18.ApiServices>(),
          gh<_i5.Cache>(),
        ));
    gh.factory<_i21.GetCredentials>(() => _i21.GetCredentials(
          gh<_i18.ApiServices>(),
          gh<_i7.FingerprintService>(),
        ));
    gh.factory<_i22.NewSaleService>(
        () => _i22.NewSaleService(gh<_i18.ApiServices>()));
    gh.singleton<_i23.ThemeHolder>(_i23.ThemeHolder(gh<_i16.ThemeLoader>()));
    gh.singleton<_i24.ThemeProvider>(
        _i24.ThemeProvider(gh<_i23.ThemeHolder>()));
    gh.factory<_i25.ThemeSelector>(
        () => _i25.ThemeSelector(gh<_i24.ThemeProvider>()));
    gh.factory<_i26.BluetoothScanBloc>(() => _i26.BluetoothScanBloc(
          gh<_i5.Cache>(),
          gh<_i18.ApiServices>(),
          gh<_i25.ThemeSelector>(),
          gh<_i3.BlePermsCheck>(),
          gh<_i14.LocationPermsCheck>(),
        ));
    gh.factory<_i27.CancelPaymentBloc>(() => _i27.CancelPaymentBloc(
          gh<_i11.InputPinPresenter>(),
          gh<_i20.CancelPaymentService>(),
        ));
    gh.factory<_i28.LoginService>(() => _i28.LoginService(
          gh<_i5.Cache>(),
          gh<_i21.GetCredentials>(),
          gh<_i25.ThemeSelector>(),
        ));
    gh.factory<_i29.NewSaleBloc>(() => _i29.NewSaleBloc(
          gh<_i9.InputAmountPresenter>(),
          gh<_i10.InputIdDocPresenter>(),
          gh<_i11.InputPinPresenter>(),
          gh<_i22.NewSaleService>(),
        ));
    gh.factory<_i30.TokenService>(() => _i30.TokenService(
          gh<_i5.Cache>(),
          gh<_i28.LoginService>(),
        ));
    gh.factory<_i31.AuthDeviceService>(() => _i31.AuthDeviceService(
          gh<_i30.TokenService>(),
          gh<_i18.ApiServices>(),
          gh<_i7.FingerprintService>(),
        ));
    gh.factory<_i32.AuthInterceptor>(() => _i32.AuthInterceptor(
          gh<_i30.TokenService>(),
          gh<_i5.Cache>(),
        ));
    gh.factory<_i33.LoginScreenBloc>(() => _i33.LoginScreenBloc(
          gh<_i28.LoginService>(),
          gh<_i5.Cache>(),
        ));
    gh.factory<_i34.LogoutService>(() => _i34.LogoutService(
          gh<_i18.ApiServices>(),
          gh<_i30.TokenService>(),
        ));
    gh.factory<_i35.AuthDeviceBloc>(() => _i35.AuthDeviceBloc(
          gh<_i31.AuthDeviceService>(),
          gh<_i28.LoginService>(),
        ));
    gh.factory<_i36.LogoutBloc>(() => _i36.LogoutBloc(
          gh<_i34.LogoutService>(),
          gh<_i5.Cache>(),
          gh<_i24.ThemeProvider>(),
        ));
    return this;
  }
}

class _$InjectionModule extends _i37.InjectionModule {}
