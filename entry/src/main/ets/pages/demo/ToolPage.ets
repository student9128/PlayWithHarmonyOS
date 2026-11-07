@Builder
export function ToolPageBuilder(){
  ToolPage()
}
@ComponentV2
export struct ToolPage {
  build() {
    Column() {
      Text('Tool')
    }
  }
}