import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { MaterialModule } from './material/material.module';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { CommonInterceptor } from '../common.interceptor';
import { NguModalModule } from '@ngu/modal';
import { AuthService } from './Auth/auth.service';
import { AuthGuard } from './Auth/auth.guard';
import { NotFoundComponent } from './core';
import { RoleGuard } from './Auth/role.guard';

@NgModule({
  imports: [CommonModule, MaterialModule, FormsModule, ReactiveFormsModule],
  declarations: [NotFoundComponent],
  providers: [
    AuthService,
    AuthGuard,
    RoleGuard,
    { provide: HTTP_INTERCEPTORS, useClass: CommonInterceptor, multi: true }
  ],
  exports: [
    CommonModule,
    HttpClientModule,
    MaterialModule,
    FormsModule,
    ReactiveFormsModule,
    NguModalModule,
    NotFoundComponent
  ]
})
export class SharedModule {}
