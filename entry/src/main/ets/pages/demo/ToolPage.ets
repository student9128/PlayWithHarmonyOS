@Builder
export function ToolPageBuilder(){
  ToolPage()
}
@Component
export struct ToolPage {
  build() {
    Column() {
      Text('Tool')
    }
  }
}