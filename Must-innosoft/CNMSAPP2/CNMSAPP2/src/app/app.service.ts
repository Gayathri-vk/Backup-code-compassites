import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { MenuDetailsRes } from './home/master/usermenu/usermenu';
import { Forgetpassword, ForgetpassRes } from './forgetpass/forgetpass';

@Injectable()
export class AppService {
  constructor(private http: HttpClient) {}

  getMenus(id) {
    return this.http.get<MenuDetailsRes>(`Menu/${id}`);
  }
  addUserPass(body) {
    return this.http.post<ForgetpassRes>('Forgetpass', body);
  }
}
