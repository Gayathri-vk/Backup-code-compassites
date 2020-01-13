import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CompanyComponent } from './company/company.component';
import { ClientComponent } from './client/client.component';
import { CountryComponent } from './country/country.component';
import { DatabasedetComponent } from './Databasedet/Databasedet.component';
import { UserdetailsComponent } from './userdetails/userdetails.component';
import { RoleGuard, AuthGuard } from '../../shared/core';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { UsermenuComponent } from './usermenu/usermenu.component';
import { SupplierComponent } from './supplier/supplier.component';
import { HolidayentryComponent } from './holidayentry/holidayentry.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'dashboard',
    pathMatch: 'full'
  },
  {
    path: 'dashboard',
    component: DashboardComponent,
    canActivate: [AuthGuard, RoleGuard]
  },
  {
    path: 'company',
    component: CompanyComponent,
    data: { state: 1 },
    canActivate: [AuthGuard, RoleGuard]
  },
  {
    path: 'client',
    component: ClientComponent,
    canActivate: [AuthGuard],
    data: { state: 2 }
  },
  {
    path: 'country',
    component: CountryComponent,
    canActivate: [AuthGuard, RoleGuard],
    data: { state: 3 }
  },
  {
    path: 'databasedet',
    component: DatabasedetComponent,
    canActivate: [AuthGuard, RoleGuard],
    data: { state: 4 }
  },
  {
    path: 'userdetails',
    component: UserdetailsComponent,
    canActivate: [AuthGuard, RoleGuard],
    data: { state: 5 }
  },
  {
    path: 'usermenu',
    component: UsermenuComponent,
    canActivate: [AuthGuard, RoleGuard],
    data: { state: 6 }
  },
  {
    path: 'supplier',
    component: SupplierComponent,
    canActivate: [AuthGuard]
  },
  {
    path: 'holidayentry',
    component: HolidayentryComponent,
    canActivate: [AuthGuard]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class MasterRoutingModule {}

export const MasterRoutedComponents = [
  CompanyComponent,
  ClientComponent,
  CountryComponent,
  DatabasedetComponent,
  UserdetailsComponent,
  DashboardComponent,
  UsermenuComponent,
  SupplierComponent,
  HolidayentryComponent
];
