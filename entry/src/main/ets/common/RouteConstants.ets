export interface CustomType {
  title: string,
  page: string
}

export interface CustomType2 {
  title: string,
  data: CustomType[]
}

export class RouteConstants {
  static readonly NOT_FOUND_PAGE = "pages/NotFoundPage"
  static readonly BASIC_COMPONENT: Array<CustomType> =
    [{ "title": "AlphabetIndexer", "page": "pages/basic_component/AlphabetIndexerPage" },
      { "title": "Blank", "page": "pages/basic_component/BlankPage" },
      { "title": "Button", "page": "pages/basic_component/ButtonPage" },
      { "title": "Checkbox", "page": "pages/basic_component/CheckboxPage" },
      // {"title":"CheckboxGroup","page":"pages/basic_component/CheckboxGroupPage"},
      { "title": "DataPanel", "page": "pages/basic_component/DataPanelPage" },
      { "title": "DatePicker", "page": "pages/basic_component/DatePickerPage" },
      { "title": "Divider", "page": "pages/basic_component/DividerPage" },
      { "title": "Gauge", "page": "pages/basic_component/GaugePage" },
      { "title": "Image", "page": "pages/basic_component/ImagePage" },
      { "title": "ImageAnimator", "page": "pages/basic_component/ImageAnimatorPage" },
      { "title": "LoadingProgress", "page": "pages/basic_component/LoadingProgressPage" },
      { "title": "Marquee", "page": "pages/basic_component/MarqueePage" },
      { "title": "Menu", "page": "pages/basic_component/MenuPage" },
      // {"title":"MenuItem","page":""},
      // {"title":"MenuItemGroup","page":""},
      { "title": "Navigation", "page": "pages/basic_component/NavigationPage" },
      { "title": "Progress", "page": "pages/basic_component/ProgressPage" },
      { "title": "QRCode", "page": "pages/basic_component/QRCodePage" },
      { "title": "Radio", "page": "pages/basic_component/RadioPage" },
      { "title": "Rating", "page": "pages/basic_component/RatingPage" },
      { "title": "RichText", "page": "pages/basic_component/RichTextPage" },
      { "title": "ScrollBar", "page": "pages/basic_component/ScrollBarPage" },
      { "title": "Search", "page": "pages/basic_component/SearchPage" },
      { "title": "Select", "page": "pages/basic_component/SelectPage" },
      { "title": "Slider", "page": "pages/basic_component/SliderPage" },
      { "title": "Span", "page": "pages/basic_component/SpanPage" },
      { "title": "Stepper", "page": "pages/basic_component/StepperPage" },
      { "title": "Text", "page": "pages/basic_component/TextPage" },
      { "title": "TextPicker", "page": "pages/basic_component/TextPickerPage" },
      { "title": "TimePicker", "page": "pages/basic_component/TimePickerPage" },
      { "title": "Toggle", "page": "pages/basic_component/TogglePage" },
      { "title": "Web", "page": "pages/basic_component/WebPage" },
      { "title": "XComponent", "page": "" },
    ]
  static readonly CONTAINER_COMPONENT: Array<CustomType> =
    [{ "title": "Badge", "page": "pages/container_component/BadgePage" }]
  static readonly FEATURE_COMPONENT: Array<CustomType> =
    [{ "title": "OrientationSwitchPage", "page": "pages/feature_component/OrientationSwitchPage" },
      { 'title': 'GridItemReorderPage', 'page': 'pages/feature_component/GridItemReorderPage' },
      { 'title': 'ListItemReorderPage', 'page': 'pages/feature_component/ListItemReorderPage' },
      { 'title': 'TabPage', 'page': 'pages/feature_component/TabPage' },
      { 'title': 'TextInputPage', 'page': "pages/feature_component/TextInputPage" },
    ]
  static readonly STUDY_LIST: Array<CustomType2> =
    [{ "title": "BasicComponent", "data": RouteConstants.BASIC_COMPONENT },
      { "title": "ContainerComponent", "data": RouteConstants.CONTAINER_COMPONENT },
      { "title": "FeatureComponent", "data": RouteConstants.FEATURE_COMPONENT },
    // { "title": "CanvasDrawComponent", "page": "pages/CanvasDrawComponent" },
    // { "title": "AnimComponent", "page": "pages/AnimComponent" },
    // { "title": "DialogComponent", "page": "pages/DialogComponent" },
    // { "title": "CustomXComponent", "page": "pages/CustomXComponent" },
    ]
  static readonly DRAWER_PAGE: string = 'pages/DrawerLayoutPage'
}