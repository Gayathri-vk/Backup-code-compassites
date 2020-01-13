import { Observable } from 'rxjs/Observable';
import { Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpInterceptor,
  HttpHandler,
  HttpRequest,
  HttpHeaders
} from '@angular/common/http';
import { AuthService } from './shared/core';
import { HttpResponse } from '@angular/common/http';
import 'rxjs/add/operator/do';

@Injectable()
export class CommonInterceptor implements HttpInterceptor {
  intercept(
    req: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    let headerss = new HttpHeaders();

    const token = localStorage.getItem('token');
    // headerss = headerss.append('Content-Type', `application/json`);
    headerss = headerss.append('Authorization', `Bearer ${token}`);

    const started = Date.now();
    // const url = 'http://18.217.186.39:81/api/';
    const url = 'http://localhost:49796/api/';
    // const url = 'http://localhost:81/api/';

    req = req.clone({
      url: url + req.url,
      headers: headerss
    });

    return next.handle(req).do(event => {
      if (event instanceof HttpResponse) {
        const elapsed = Date.now() - started;
        console.log(`Request for ${req.urlWithParams} took ${elapsed} ms.`);
      }
    });
  }
}
