import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { BOQDetail } from './boqdetailreport/boqdetailreport';
import { BOQMainDetail } from './boqmainitemreport/boqmainitemreport';
import { BOQSubDetail } from './boqsubitemreport/boqsubitemreport';
import { BOQSubSubDetail } from './boqsubsubitemreport/boqsubsubitemreport';
import { BOQVarDetail } from './boqvariationreport/boqvariationreport';
import { BOQCriticalPath } from './boqcriticalpathreport/boqcriticalpathreport';

@Injectable()
export class ReportsService {
  constructor(private http: HttpClient) {}

  // -------------------------------- BOQ Detail -------------------------------------

  getBOQAll(id) {
    return this.http.get<BOQDetail[]>(`BOQDetailReport/${id}`);
  }
  getBOQmain(id) {
    return this.http.get<BOQMainDetail[]>(`BOQDetailReport/${id}`);
  }
  getBOQsub(id) {
    return this.http.get<BOQSubDetail[]>(`BOQDetailReport/${id}`);
  }
  getBOQsubsub(id) {
    return this.http.get<BOQSubSubDetail[]>(`BOQDetailReport/${id}`);
  }
  getBOQVarAll(id) {
    return this.http.get<BOQVarDetail[]>(`BOQDetailReport/${id}`);
  }
  getBOQCPath(id) {
    return this.http.get<BOQCriticalPath[]>(`BOQDetailReport/${id}`);
  }
}
