
import 'package:fine_taste/pages/order/order_list.dart';
import 'package:fine_taste/pages/repositories/login/login_api.dart';

import '../app/arch/bloc_provider.dart';
import '../common/validators/validators.dart';
import '../pages/home/bloc/home_page_bloc.dart';
import '../pages/home/widget/home_page.dart';
import '../pages/notifications/bloc/notificatiion_bloc.dart';
import '../pages/notifications/notification_page.dart';
import '../pages/order/bloc/create_order_bloc.dart';
import '../pages/order/bloc/order_details_bloc.dart';
import '../pages/order/bloc/order_list_bloc.dart';
import '../pages/order/create_order.dart';
import '../pages/order/order_details.dart';
import '../pages/profile/bloc/profile_bloc.dart';
import '../pages/profile/widget/profile_page.dart';
import '../pages/store/bloc/store_list_bloc.dart';
import '../pages/store/store_list.dart';
import 'app_injector.dart';

extension HomePageExtension on AppInjector {
  HomePageFactory get  homePage => container.get();
  ProfilePageFactory get  profilePage => container.get();
  NotificationFactory get  notification => container.get();
  StoreListFactory get storeList => container.get();
  CreateOrderFactory get orderCreate => container.get();
  OrderListFactory get orderList => container.get();
  OrderDetailsFactory get orderDetails => container.get();

  registerHomePage(){
    container.registerDependency<HomePageFactory>((){
      return()=> BlocProvider<HomePageBloc>(bloc: HomePageBloc(userDataStore,LoginService()), child:  HomePage());
    });

    container.registerDependency<ProfilePageFactory>((){
      return()=> BlocProvider<ProfilePageBloc>(bloc: ProfilePageBloc(FormValidator(),LoginService(),userDataStore), child:  ProfilePage());
    });

    container.registerDependency<NotificationFactory>((){
      return()=> BlocProvider<NotificationBloc>(bloc: NotificationBloc(LoginService(),userDataStore), child:  NotificationPage());
    });

    container.registerDependency<StoreListFactory>((){
      return(type)=> BlocProvider<StoreListBloc>(bloc: StoreListBloc(LoginService(),type,userDataStore), child:  StoreList());
    });

    container.registerDependency<OrderListFactory>((){
      return(type)=> BlocProvider<OrderListBloc>(bloc: OrderListBloc(type,LoginService(),userDataStore), child:  OrderList());
    });

    container.registerDependency<OrderDetailsFactory>((){
      return(order)=> BlocProvider<OrderDetailsBloc>(bloc: OrderDetailsBloc(userDataStore,LoginService(),order), child:  OrderDetails());
    });
    container.registerDependency<CreateOrderFactory>((){
      return(store)=> BlocProvider<CreateOrderBloc>(bloc: CreateOrderBloc(LoginService(),userDataStore,store), child:  CreateOrder());
    });
  }

}