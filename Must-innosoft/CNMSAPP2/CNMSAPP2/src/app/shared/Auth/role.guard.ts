import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import {
  CanActivate,
  Router,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
  CanActivateChild,
  NavigationExtras,
  CanLoad,
  Route
} from '@angular/router';

import { AuthService } from './auth.service';
import { RoleData } from '../../navigation/navigation';

@Injectable()
export class RoleGuard implements CanActivate, CanActivateChild, CanLoad {
  constructor(private authService: AuthService, private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    const url: string = state.url;
    return this.verfiyUrl(url);
  }

  canActivateChild(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    return this.canActivate(route, state);
  }

  canLoad(route: Route): boolean {
    const url = `/${route.path}`;
    return this.verfiyUrl(url);
  }

  verfiyUrl(url) {
    // const RoleData = this.authService.userMenu;
    const splitUrl = url.split('/');
    const comb =
      splitUrl[1] === 'home'
        ? splitUrl[2] + '/' + splitUrl[3]
        : splitUrl[1] + '/' + splitUrl[2];
    for (let i = 0; i < RoleData.length; i++) {
      for (let j = 0; j < RoleData[i].list.length; j++) {
        console.log(RoleData[i].list[j]);
        console.log(comb);
        if (RoleData[i].list[j].route === comb) {
          console.log(url);
          // console.log(RoleData[i].list[j].role.indexOf(this.authService.userRole));
          // if (
          //   RoleData[i].list[j].role.indexOf(this.authService.userRole) !== -1
          // ) {
            return true;
          // }
          // this.router.navigate(['/home/master/dashboard']);
          // return false;
        }
      }
    }
  }
}
