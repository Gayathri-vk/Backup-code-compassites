import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RoleGuard, AuthGuard } from '../../shared/core';
import { LocationdetailsComponent } from './locationdetails/locationdetails.component';
import { ProjectdetailsComponent } from './projectdetails/projectdetails.component';
import { ProjectdescriptionComponent } from './projectdescription/projectdescription.component';
import { MainItemComponent } from './main-item/main-item.component';
import { SubItemComponent } from './sub-item/sub-item.component';
import { SubSubItemComponent } from './sub-sub-item/sub-sub-item.component';
import { BoqdetailsComponent } from './boqdetails/boqdetails.component';
import { BoqComponent } from './boq/boq.component';
import { BoqviewComponent } from './boqview/boqview.component';
import { BoqprocessComponent } from './boqprocess/boqprocess.component';
import { BoqvariationComponent } from './boqvariation/boqvariation.component';
import { BoqreviseComponent } from './boqrevise/boqrevise.component';
import { BoqreviseviewComponent } from './boqreviseview/boqreviseview.component';
import { BoqupdateComponent } from './boqupdate/boqupdate.component';
import { ReviseboqComponent } from './reviseboq/reviseboq.component';
import { ImportBoqComponent } from './import-boq/import-boq.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'location',
    pathMatch: 'full'
  },
  {
    path: 'location',
    component: LocationdetailsComponent,
    canActivate: [AuthGuard, RoleGuard]
  },
  {
    path: 'project',
    component: ProjectdetailsComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'projectdescription',
    component: ProjectdescriptionComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'main-item',
    component: MainItemComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'sub-item',
    component: SubItemComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'sub-sub-item',
    component: SubSubItemComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqdetails',
    component: BoqdetailsComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqupdate',
    component: BoqupdateComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boq',
    component: BoqComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqvariation',
    component: BoqvariationComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqview',
    component: BoqviewComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqprocess',
    component: BoqprocessComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'reviseboq',
    component: ReviseboqComponent,
    canActivate: [AuthGuard]
    // path: 'boqrevise',
    // component: BoqreviseComponent,
    // canActivate: [AuthGuard]
  },
  {
    path: 'boqreviseview',
    component: BoqreviseviewComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'import-boq',
    component: ImportBoqComponent,
    canActivate: [AuthGuard]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProcessRoutingModule {}

export const ProcessRoutedComponents = [
  LocationdetailsComponent,
  ProjectdetailsComponent,
  ProjectdescriptionComponent,
  MainItemComponent,
  SubItemComponent,
  SubSubItemComponent,
  BoqdetailsComponent,
  BoqComponent,
  BoqviewComponent,
  BoqprocessComponent,
  BoqvariationComponent,
  BoqreviseComponent,
  BoqreviseviewComponent,
  BoqupdateComponent,
  ReviseboqComponent,
  ImportBoqComponent
];
