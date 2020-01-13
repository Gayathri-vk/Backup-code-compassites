import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RoleGuard, AuthGuard } from '../../shared/core';
import { BoqdetailreportComponent } from './boqdetailreport/boqdetailreport.component';
import { BoqreportsComponent } from './boqreports/boqreports.component';
import { BoqmainitemreportComponent } from './boqmainitemreport/boqmainitemreport.component';
import { BoqsubitemreportComponent } from './boqsubitemreport/boqsubitemreport.component';
import { BoqsubsubitemreportComponent } from './boqsubsubitemreport/boqsubsubitemreport.component';
import { BoqvariationComponent } from '../process/boqvariation/boqvariation.component';
import { BoqvariationreportComponent } from './boqvariationreport/boqvariationreport.component';
import { BoqcriticalpathreportComponent } from './boqcriticalpathreport/boqcriticalpathreport.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'boqreports',
    pathMatch: 'full'
  },
  {
    path: 'boqreports',
    component: BoqreportsComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqdetailreport',
    component: BoqdetailreportComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqmainitemreport',
    component: BoqmainitemreportComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqsubitemreport',
    component: BoqsubitemreportComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqsubsubitemreport',
    component: BoqsubsubitemreportComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqvariationreport',
    component: BoqvariationreportComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'boqcriticalpathreport',
    component: BoqcriticalpathreportComponent,
    canActivate: [AuthGuard]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportsRoutingModule {}

export const ReportsRoutedComponents = [
  BoqdetailreportComponent,
  BoqreportsComponent,
  BoqmainitemreportComponent,
  BoqsubitemreportComponent,
  BoqsubsubitemreportComponent,
  BoqvariationreportComponent,
  BoqcriticalpathreportComponent
];
