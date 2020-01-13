import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpErrorResponse,
  HttpParams
} from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import {} from '@angular/common/http/src/params';
import { JwtHelper, tokenNotExpired } from 'angular2-jwt';
import { MenuDetailsRes } from '../../home/master/usermenu/usermenu';

@Injectable()
export class AuthService {
  private userMenuData: any;
  userroleID: any;
  constructor(private http: HttpClient) {}

  login(user) {
    return new Promise((resolve, reject) => {
      this.http.post<LoginDet>(`userlogin`, user).subscribe(
        res => {
          if (res.status) {
            localStorage.setItem('token', res.tokenString);
            localStorage.setItem('expieMsg', res.message);
            // this.userMenuSer().subscribe(dat => {
            //   console.log(dat);
            //   localStorage.setItem('userMenu', JSON.stringify(dat));
            //   this.userMenuData = dat;
            // });
            resolve(res);
          } else {
            resolve(res);
          }
        },
        (err: HttpErrorResponse) => {
          if (err.error instanceof Error) {
            // A client-side or network error occurred. Handle it accordingly.
            console.log('An error occurred:', err.error.message);
          } else {
            // The backend returned an unsuccessful response code.
            // The response body may contain clues as to what went wrong,
            console.log(
              `Backend returned code ${err.status}, body was: ${JSON.stringify(
                err.error
              )}`
            );
          }
        }
      );
    });
  }

  get userMenu() {
    if (this.userMenuData) {
      return this.userMenuData;
    } else {
      this.userMenuData = JSON.parse(localStorage.getItem('userMenu'));
      return this.userMenuData;
    }
  }

  set userMenu(dat) {
    this.userMenuData = dat;
  }

  userMenuSer() {
    return this.http.get<MenuDetailsRes>(`Menu/${this.userRole}`);
  }
  // login(user) {
  //   return new Promise((resolve, reject) => {
  //     this.http.get<LoginDet>(`userlogin`, { params: user }).subscribe(
  //       res => {
  //         if (res.status) {
  //           localStorage.setItem('token', res.tokenString);
  //           resolve(res);
  //         } else {
  //           resolve(res);
  //         }
  //       },
  //       (err: HttpErrorResponse) => {
  //         if (err.error instanceof Error) {
  //           // A client-side or network error occurred. Handle it accordingly.
  //           console.log('An error occurred:', err.error.message);
  //         } else {
  //           // The backend returned an unsuccessful response code.
  //           // The response body may contain clues as to what went wrong,
  //           console.log(
  //             `Backend returned code ${err.status}, body was: ${JSON.stringify(
  //               err.error
  //             )}`
  //           );
  //         }
  //       }
  //     );
  //   });
  // }

  get isLoggedIn() {
    return tokenNotExpired();
  }

  logout(): void {
    localStorage.clear();
  }

  get userRole() {
    const token = localStorage.getItem('token');
    if (!token) {
      return -1;
    }
    const jwtHelper = new JwtHelper();
    const user = jwtHelper.decodeToken(token);
    return +user['userrole'];
  }

  get ExpireMsg() {
    const token = localStorage.getItem('expieMsg');
    return token || '';
  }

  get clientId() {
    const token = localStorage.getItem('token');
    if (!token) {
      return -1;
    }
    const jwtHelper = new JwtHelper();
    const user = jwtHelper.decodeToken(token);
    return +user['clientid'];
  }
}

interface LoginDet {
  message: string;
  status: Boolean;
  userrole: string;
  tokenString: string;
  token: string;
}
