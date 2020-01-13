import { Injectable } from '@angular/core';

import 'rxjs/add/operator/toPromise';
import { HttpClient } from '@angular/common/http';
import { Link } from './boqdetails';

@Injectable()
export class LinkService {
  private linkUrl = 'api/links';

  constructor(private http: HttpClient) {}

  get(): Promise<Link[]> {
    return this.http.get<Link[]>('BOQ').toPromise();
  }

  insert(link: Link): Promise<Link> {
    return this.http.post<Link>('BoqProcess', JSON.stringify(link)).toPromise();
  }

  update(link: Link): Promise<void> {
    return this.http
      .put<any>(`${this.linkUrl}/${link.id}`, JSON.stringify(link))
      .toPromise();
  }

  remove(id: number): Promise<void> {
    return this.http.delete<any>(`${this.linkUrl}/${id}`).toPromise();
  }
}
