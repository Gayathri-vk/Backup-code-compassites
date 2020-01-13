import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { DashboardComponent } from './home/dashboard/dashboard.component';
import { AuthGuard, RoleGuard } from './shared/core';
import { ClientRegComponent } from './client-reg/client-reg.component';
import { ForgetpassComponent } from './forgetpass/forgetpass.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'login',
    pathMatch: 'full'
  },
  {
    path: 'login',
    component: LoginComponent
  },
  {
    path: 'home',
    component: HomeComponent,
    canActivateChild: [AuthGuard],
    children: [
      {
        path: '',
        redirectTo: 'master',
        pathMatch: 'full'
      },
      {
        path: 'master',
        loadChildren: './home/master/master.module#MasterModule',
        canActivateChild: []
      },
      {
        path: 'process',
        loadChildren: './home/process/process.module#ProcessModule',
        canActivateChild: []
      },
      {
        path: 'reports',
        loadChildren: './home/reports/reports.module#ReportsModule',
        canActivateChild: []
      }
    ]
  },
  {
    path: 'client-reg',
    component: ClientRegComponent
  },
  {
    path: 'forgetpass',
    component: ForgetpassComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}

export const AppRoutingComponents = [
  LoginComponent,
  ClientRegComponent,
  ForgetpassComponent
];
