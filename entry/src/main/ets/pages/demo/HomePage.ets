@Builder
export function HomePageBuilder(){
  HomePage()
}
@ComponentV2
export struct HomePage {
  build() {
    Column() {
      Text('Home')
    }
  }
}