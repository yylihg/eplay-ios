/**
 * Created by yanlin.yyl on 2017/9/2.
 */

import  {
    NativeModules
} from 'react-native';

var ReactModule = NativeModules.ReactModule;
export default class UserUtils {
    static getUser(callback){
        ReactModule.getUser(function (result) {
            callback(result);
        })
    }
}