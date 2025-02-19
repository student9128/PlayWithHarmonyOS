@Builder
export function HomePageBuilder(){
  HomePage()
}
@Component
export struct HomePage {
  build() {
    Column() {
      Text('Home')
    }
  }
}