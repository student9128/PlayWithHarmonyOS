import { TextModifier } from '@ohos.arkui.modifier';
import { playFont } from './Global';

export class PlayFontStyle implements AttributeModifier<TextModifier>{
  applyNormalAttribute(instance: TextModifier): void {
    instance.fontFamily(playFont).fontSize(14).fontColor('#8D493A')
  }
}
export class PlayFixedFontStyle implements AttributeModifier<TextModifier>{
  applyNormalAttribute(instance: TextModifier): void {
    instance.fontFamily(playFont)
      .fontSize(14)
      .fontColor('#8D493A')
      .minFontScale(1.0)
      .maxFontScale(1.0)
      .fontWeight(500)
  }
}