/**
 * Created by yanlin.yyl on 2017/9/2.
 */

import  {
    NativeModules
} from 'react-native';

var ReactModule = NativeModules.ReactModule;
import UserUtils from './UserUtils'


var findNodeHandle = require('findNodeHandle');
export default class RequestUtils {
    static fetch(self, method, params, callback){
        ReactModule.fetch(method, params, function (error, response) {
            if (!response){
                return;
            }
            console.log(response.code || "" + "ihg RequestUtils" + JSON.stringify(response));


            if (response.code == '90002' || response.code == '90003' || response.code == '90005'){
                alert(response.errorMsg || '');
            }

            if (response.code == '90000' || response.code == '90001'){
                ReactModule.getAccessToken(function () {
                    RequestUtils.fetch(self, method, params, callback);
                })
                return;
            }
            if (response.code == '90004' || response.code == '90006'){
                UserUtils.getUser(function (result) {
                    if(result.username && result.password){
                        ReactModule.doLogin(result.username, result.password, function () {
                            RequestUtils.fetch(self, method, params, callback);
                        })
                    }else {
                        // ReactModule.pushLoginController(findNodeHandle(self), function (e) {
                        //     alert(JSON.stringify(e))
                        // })
                        callback(response);
                    }
                })
                return;
            }
            callback(response);
        });
    }
}