import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import {
  LocationMasterRes,
  LocationMaster
} from './locationdetails/locationdetails';
import {
  ProjectMaster,
  ProjectMasterRes,
  ClientProjectRes
} from './projectdetails/projectdetails';
import { MainItemMaster, MainItemMasterRes } from './main-item/main-item';
import { SubItemMaster, SubItemMasterRes } from './sub-item/sub-item';
import {
  SubSubItemMaster,
  SubSubItemMasterRes
} from './sub-sub-item/sub-sub-item';
import {
  ExternalWorkMasterRes,
  ProjectDescriptionList,
  ProjectDescriptionRes
} from './projectdescription/project-description';
import { BoqdetailsComponent } from './boqdetails/boqdetails.component';
import { Observable } from 'rxjs/Observable';
import * as io from 'socket.io-client';
import {
  ProjectDescriptionDetails,
  MainItemMasterDetails,
  BoqRes,
  Task,
  Link,
  Boqdep
} from './boqdetails/boqdetails';
import { BoqDescListRes } from './boq/boq';
import {
  BOQTASK,
  BOQPRO,
  BOQTASKRes,
  BOQTASKUPP,
  BOQDATA,
  BOQMainItem,
  BOQSubItem,
  BOQSubSubItem,
  BOQWorkPer
} from './boqprocess/boqprocess';
import {
  SubItemMasterDetails,
  TaskV,
  BoqResV
} from './boqvariation/boqvariation';
import { BOQREV, BOQREVRes } from './boqrevise/boqrevise';
import { BOQReviceDetail } from './boqreviseview/boqreviseview';
import { MenuDetailsRes } from '../master/usermenu/usermenu';
import { HolidayRes } from './boqview/boqview';

@Injectable()
export class ProcessService {
  private url = 'http://localhost:4200';
  private socket;

  constructor(private http: HttpClient) {}

  // -------------------------------- Meni -------------------------------------
  getMenus(id) {
    return this.http.get<MenuDetailsRes>(`Menu/${id}`);
  }

  // -------------------------------- Location -------------------------------------

  getLocation() {
    return this.http.get<LocationMaster[]>('Location');
  }

  addLocation(body) {
    return this.http.post<LocationMasterRes>('Location', body);
  }

  updateLocation(body) {
    return this.http.post<LocationMasterRes>(`Location`, body);
  }

  // -------------------------------- Project -------------------------------------

  getProject() {
    return this.http.get<ProjectMaster[]>('Project');
  }

  addProject(body) {
    return this.http.post<ProjectMasterRes>('Project', body);
  }

  updateProject(body) {
    return this.http.post<ProjectMasterRes>(`Project`, body);
  }

  getClient(id) {
    return this.http.get<ClientProjectRes>(`Project/${id}`);
  }
  getProjectDet(id) {
    return this.http.get<ProjectMaster[]>(`Project/${id}`);
  }
  // -------------------------------- MainItem -------------------------------------

  getMainItem() {
    return this.http.get<MainItemMaster[]>('MainItem');
  }

  addMainItem(body) {
    return this.http.post<MainItemMasterRes>('MainItem', body);
  }

  updateMainItem(body) {
    return this.http.post<MainItemMasterRes>(`MainItem`, body);
  }
  // -------------------------------- SubItem -------------------------------------

  getSubItem() {
    return this.http.get<SubItemMaster[]>('SubItem');
  }

  addSubItem(body) {
    return this.http.post<SubItemMasterRes>('SubItem', body);
  }

  updateSubItem(body) {
    return this.http.post<SubItemMasterRes>(`SubItem`, body);
  }
  getSubItemLite(id) {
    return this.http.get<SubItemMaster[]>(`SubItem/${id}`);
  }
  // -------------------------------- SubSubItem -------------------------------------

  getSubSubItem() {
    return this.http.get<SubSubItemMaster[]>('SubSubItem');
  }

  addSubSubItem(body) {
    return this.http.post<SubSubItemMasterRes>('SubSubItem', body);
  }

  updateSubSubItem(body) {
    return this.http.post<SubSubItemMasterRes>(`SubSubItem`, body);
  }
  // -------------------------------- ProjectDescription -------------------------------------
  getExternalMaser(id) {
    return this.http.get<ExternalWorkMasterRes[]>(`ProjectDescription/${id}`);
  }
  addProjectDescription(body) {
    return this.http.post<ProjectDescriptionRes>('ProjectDescription', body);
  }

  getProjectDescription(id) {
    return this.http.get<ProjectDescriptionList>(`ProjectDescription/${id}`);
  }

  // ------------------- gantt -----------------------------------------

  sendModel(model) {
    this.socket.emit('send-model', model);
  }

  getDescription(id) {
    return this.http.get<ProjectDescriptionDetails[]>(`boq/${id}`);
  }

  getMainItemDet(id) {
    return this.http.get<MainItemMasterDetails[]>(`boq/${id}`);
  }
  getModel() {
    const observable = new Observable(observer => {
      this.socket = io(this.url);
      this.socket.on('get-model', data => {
        console.log('in gantt service get model');
        observer.next(data);
      });
      return () => {
        this.socket.disconnect();
      };
    });
    return observable;
  }
  // ------------------- boq -----------------------------------------
  getBoqItem(id) {
    return this.http.get<Task[]>(`BOQ/${id}`);
  }
  addBoqdata(body) {
    return this.http.get<BoqDescListRes>('BOQ', body);
  }
  addboq(body, id) {
    return this.http.post<BoqRes>(`BOQ/${id}`, body);
  }
  getBoqlink(id) {
    return this.http.get<Link[]>(`BOQ/${id}`);
  }
  getBoqdep(id, val, sub) {
    return this.http.get<Boqdep[]>(`BOQ/?id=${id}&val=${val}&sub=${sub}`);
  }
  bolinkupdatet(body, id) {
    return this.http.post<BoqRes>(`BOQ/${id}`, body);
  }
  // ------------------- boq process-----------------------------------------
  getBoqpro(id) {
    return this.http.get<BOQTASKUPP>(`BoqProcess/${id}`);
  }
  getBoqItemLite(id) {
    return this.http.get<BOQPRO[]>(`BoqProcess/${id}`);
  }
  getBoqData(id) {
    return this.http.get<BOQDATA[]>(`BoqProcess/${id}`);
  }
  boqProcessSubmit(body) {
    return this.http.post<BOQTASKRes>('BoqProcess', body);
  }
  boqWDSubmit(body) {
    return this.http.post<BOQTASKRes>('BoqProcess', body);
  }
  getBoqMainItem() {
    return this.http.get<BOQMainItem[]>('BoqProcess');
  }
  getBoqSubItem(id, val) {
    return this.http.get<BOQSubItem[]>(`BoqProcess/?id=${id}&val=${val}`);
  }
  getBoqSubSubItem(id, val) {
    return this.http.get<BOQSubSubItem[]>(`BoqProcess/?id=${id}&val=${val}`);
  }
  getBoqWorkPer(id, val) {
    return this.http.get<BOQWorkPer[]>(`BoqProcess/?id=${id}&val=${val}`);
  }
  boqFProcessSubmit(body) {
    return this.http.post<BOQTASKRes>('BoqProcess', body);
  }
  getHoliday(id) {
    return this.http.get<HolidayRes[]>(`BoqProcess/${id}`);
  }
  // ------------------- boq variation-----------------------------------------
  getVaraitionDet() {
    return this.http.get<SubItemMasterDetails[]>('BOQVariation');
  }
  getBoqVarItem(id) {
    return this.http.get<TaskV[]>(`BOQVariation/${id}`);
  }
  addboqvar(body) {
    return this.http.post<BoqResV>('BOQVariation', body);
  }
  // ------------------- boq Revise-----------------------------------------
  getReviseItem(id) {
    return this.http.get<BOQREV[]>(`BOQRevise/${id}`);
  }
  boqReviseSubmit(body) {
    return this.http.post<BOQREVRes>('BOQRevise', body);
  }
  getBOQRevice(id) {
    return this.http.get<BOQReviceDetail[]>(`BOQRevise/${id}`);
  }
}
