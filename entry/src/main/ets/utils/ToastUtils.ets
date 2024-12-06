import { promptAction } from "@kit.ArkUI"

export const showToast = (msg: string | Resource, option?: toastOptions) => {
  promptAction.showToast({
    message: msg,
    duration: option?.duration,
    bottom: option?.bottom,
    showMode: option?.showMode,
    backgroundColor: option?.backgroundColor ?? $r('app.color.start_window_background'),
    alignment: option?.alignment,
    offset: option?.offset,
    textColor: option?.textColor ?? $r('app.color.text_color'),
    backgroundBlurStyle: BlurStyle.NONE,
    shadow: option?.shadow
  })
}

export const showToastLong = (msg: string | Resource, option?: toastOptions) => {
  promptAction.showToast({
    message: msg,
    duration: option?.duration ?? 3000,
    bottom: option?.bottom,
    showMode: option?.showMode,
    backgroundColor: option?.backgroundColor,
    alignment: option?.alignment,
    offset: option?.offset,
    textColor: option?.textColor,
    backgroundBlurStyle: option?.backgroundColor != null ? BlurStyle.NONE : option?.backgroundBlurStyle,
    shadow: option?.shadow
  })
}

interface toastOptions {
  duration?: number;
  bottom?: string | number;
  showMode?: promptAction.ToastShowMode;
  alignment?: Alignment;
  offset?: Offset;
  backgroundColor?: ResourceColor;
  textColor?: ResourceColor;
  backgroundBlurStyle?: BlurStyle;
  shadow?: ShadowOptions | ShadowStyle;
}