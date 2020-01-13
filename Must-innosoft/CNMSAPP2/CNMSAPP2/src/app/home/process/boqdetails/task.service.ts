import { Injectable } from '@angular/core';

import 'rxjs/add/operator/toPromise';
import { HttpClient } from '@angular/common/http';
import { Task } from './boqdetails';

@Injectable()
export class TaskService {
  // private taskUrl = 'BOQ';

  constructor(private http: HttpClient) {}

  get(): Promise<Task[]> {
    return this.http.get<Task[]>('BOQ').toPromise();
  }

  insert(task: Task): Promise<Task> {
    return this.http.post<Task>('BOQ', JSON.stringify(task)).toPromise();
  }

  update(task: Task): Promise<void> {
    return this.http
      .put<any>(`BOQ/${task.id}`, JSON.stringify(task))
      .toPromise();
    // return this.http.post<Task>('BOQ', JSON.stringify(task)).toPromise();
  }

  // remove(id: number): Promise<void> {
  //   return this.http.delete<any>(`BOQ/${id}`).toPromise();
  // }
}
