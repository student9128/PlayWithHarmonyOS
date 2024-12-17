import { CustomColors } from '@kit.ArkUI';

export class GreenColors implements CustomColors{
  fontPrimary?: ResourceColor | undefined=Color.Green
  backgroundPrimary?: ResourceColor | undefined='#E3F0AF'
  backgroundSecondary?: ResourceColor | undefined='#5DB996'
  brand?: ResourceColor | undefined='#527853'
  iconPrimary?: ResourceColor | undefined='#527853'
  compBackgroundEmphasize?: ResourceColor | undefined='#FF9800'

}
export class PageCustomTheme implements CustomTheme{
  colors?: CustomColors;

  constructor(colors: CustomColors) {
    this.colors = colors;
  }

}