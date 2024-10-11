import '../styles/domain/app_theme.dart';

getImgName(String name,AppTheme apptheme){
      String nameSelected;
      switch (name) {
        case "new-sales":
            nameSelected= apptheme.assetsImg.pos;
          break;
        case "last-transaction":
            nameSelected= apptheme.assetsImg.last;
          break;
        case "transactions":
            nameSelected= apptheme.assetsImg.transactions;
          break;
        case "total-report":
            nameSelected= apptheme.assetsImg.report;
          break;
        case "simple-report":
            nameSelected= apptheme.assetsImg.simple;
          break;
        case "detailed-report":
            nameSelected= apptheme.assetsImg.details;
          break;
        case "close-pos":
            nameSelected= apptheme.assetsImg.closed;
          break;
        case "technical-management":
            nameSelected= apptheme.assetsImg.test;
          break;
        default:
          nameSelected = "";
      }
      return nameSelected;
    }

getSubtitle(String name){
      String nameSelected = "";
      switch (name) {
        case "new-sales":
            nameSelected= "NUEVA VENTA";
          break;
        case "last-transaction":
            nameSelected= "ULTIMA TRANSACCION";
          break;
        case "transactions":
            nameSelected= "TRANSACCIONES";
          break;
        case "total-report":
            nameSelected= "REPORTE TOTAL";
          break;
        case "simple-report":
            nameSelected= "REPORTE SIMPLE";
          break;
        case "detailed-report":
            nameSelected= "REPORTE DETALLADO";
          break;
        case "close-pos":
            nameSelected= "CIERRA DE PUNTO";
          break;
        case "technical-management":
            nameSelected= "TEST";
          break;
        default:
          nameSelected = "";
      }
      return nameSelected;
    }
getRoute(String name){
      String nameSelected = "";
      switch (name) {
        case "new-sales":
            nameSelected= "new_sales";
          break;
        case "last-transaction":
            nameSelected= "last";
          break;
        case "transactions":
            nameSelected= "transactions";
          break;
        case "total-report":
            nameSelected= "total";
          break;
        case "simple-report":
            nameSelected= "simple";
          break;
        case "detailed-report":
            nameSelected= "details";
          break;
        case "close-pos":
            nameSelected= "close";
          break;
        case "technical-management":
            nameSelected= "test";
          break;
        default:
          nameSelected = "";
      }
      return nameSelected;
    }