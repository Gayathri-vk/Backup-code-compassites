import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HolidayentryComponent } from './holidayentry.component';

describe('HolidayentryComponent', () => {
  let component: HolidayentryComponent;
  let fixture: ComponentFixture<HolidayentryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HolidayentryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HolidayentryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
