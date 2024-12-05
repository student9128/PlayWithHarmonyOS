import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { font } from '@kit.ArkUI';
import { playFont } from '../common/Global';
import { Configuration } from '@ohos.app.ability.Configuration';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { key_window_class } from '../common/Key';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    AppStorage.setOrCreate('currentColorMode', this.context.config.colorMode);
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  mWindowClass: window.Window | undefined = undefined;

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.getMainWindow((err, windowClass) => {
      if (err.code) {
        hilog.info(0x0000, 'testTag', '%{public}s', JSON.stringify(err));
      }
      this.mWindowClass = windowClass
      // //状态栏、导航栏的属性
      var SystemBarProperties = {
        statusBarColor: '#2196f3', // 状态栏背景色透明
        //navigationBarColor: '#00ff00',
        // 以下两个属性从API Version7开始支持
        isStatusBarLightIcon: false,
        //isNavigationBarLightIcon: false,
        // 以下两个属性从API Version8开始支持
        statusBarContentColor: '#ffff00',
        navigationBarContentColor: '#000000'
      };
      // windowClass.setSystemBarProperties(SystemBarProperties,(err)=>{
      //   console.log("Hello",JSON.stringify(err))
      // })
      // windowClass.setWindowLayoutFullScreen(true,(error,data)=>{
      //   if(err.code==0){
      //     hilog.info(0x0000, 'testTag', '%{public}s', '设置成功');
      //   }else {
      //     hilog.info(0x0000, 'testTag', '%{public}s', '设置失败');
      //   }
      // })
      // windowClass.setWindowSystemBarEnable(["navigation"])
      let color: string =this.context.config.colorMode==0 ? '#2D3250' : '#F8EDE3';
      let statusBarContentColor: string = this.context.config.colorMode == 0 ? '#BF9742' : '#8D493A';
      windowClass.setWindowSystemBarProperties({
        statusBarColor: color, statusBarContentColor:statusBarContentColor
      }, (err) => {
        console.log(`${JSON.stringify(err)}`);
      })
      windowClass.setUIContent('pages/Index', (err) => {
        if (err.code == 0) {
          try {
            windowClass.setWindowBackgroundColor(color);
          } catch (exception) {
            console.error('Failed to set the background color. Cause: ' + JSON.stringify(exception));
          }
          font.registerFont({
            familyName: playFont, familySrc: 'font/custom_font.ttf'
          })

        }
      })
      AppStorage.setOrCreate(key_window_class, windowClass);
      // windowClass.setWindowBackgroundColor('#2196f3')
    })

    // windowStage.loadContent('pages/Index', (err, data) => {
    //   if (err.code) {
    //     hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
    //     return;
    //   }
    //   hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    // });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    let newColorMode = newConfig.colorMode
    let currentColorMode = AppStorage.get<ConfigurationConstant.ColorMode>('currentColorMode');
    if (newColorMode === currentColorMode) {
      return;
    }
    console.log("colorMode===" + newColorMode,)
    this.setColorMode(newColorMode);
    AppStorage.setOrCreate('currentColorMode', newConfig.colorMode);
    // if()
  }

  private setColorMode(newColorMode: ConfigurationConstant.ColorMode | undefined) {
    let color: string = newColorMode == 0 ? '#2D3250' : '#F8EDE3';
    let statusBarContentColor: string = newColorMode == 0 ? '#BF9742' : '#8D493A';
    if (this.mWindowClass != undefined) {
      this.mWindowClass.setWindowSystemBarProperties({
        statusBarColor: color, statusBarContentColor: statusBarContentColor
      }, (err) => {
        console.log(`${JSON.stringify(err)}`);
      });
      this.mWindowClass.setWindowBackgroundColor(color);
    }
  }
}
