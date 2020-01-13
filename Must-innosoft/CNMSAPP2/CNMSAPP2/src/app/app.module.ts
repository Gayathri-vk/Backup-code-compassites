import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';

import { AppRoutingModule, AppRoutingComponents } from './app.routing';

import { AppComponent } from './app.component';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { NavigationComponent } from './navigation/navigation.component';
import { NguAlertModule } from '@ngu/alert';
import { SharedModule } from './shared/shared.module';
import { RolePipe } from './navigation/role.pipe';
import { AppService } from './app.service';
import { CommonModule } from '@angular/common';
import { ChartsModule } from 'ng2-charts';

import { HttpModule } from '../../node_modules/@angular/http';

@NgModule({
  declarations: [
    AppComponent,
    NavigationComponent,
    AppRoutingComponents,
    RolePipe,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    NguAlertModule,
    SharedModule,
    CommonModule,
    ChartsModule,
    HttpModule
  ],
  providers: [AppService],
  bootstrap: [AppComponent]
})
export class AppModule {}
