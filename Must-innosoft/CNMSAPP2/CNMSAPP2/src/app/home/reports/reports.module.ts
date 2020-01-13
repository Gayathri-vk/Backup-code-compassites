import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  ReportsRoutedComponents,
  ReportsRoutingModule
} from './reports.routing';
import { SharedModule } from '../../shared/shared.module';
import { ReportsService } from './reports.service';

@NgModule({
  imports: [CommonModule, ReportsRoutingModule, SharedModule],
  declarations: [ReportsRoutedComponents],
  providers: [ReportsService]
})
export class ReportsModule {}
