import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/of';
import { PreloadingStrategy, Route } from '@angular/router';

export class CustomPreloading implements PreloadingStrategy {
  preload(route: Route, preload: Function): Observable<any> {
    if (route.data && route.data.preload) {
      return preload();
    } else {
      return Observable.of(null);
    }
  }
}
