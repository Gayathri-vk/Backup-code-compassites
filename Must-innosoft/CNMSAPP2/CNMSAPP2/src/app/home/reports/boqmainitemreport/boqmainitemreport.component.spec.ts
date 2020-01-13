import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqmainitemreportComponent } from './boqmainitemreport.component';

describe('BoqmainitemreportComponent', () => {
  let component: BoqmainitemreportComponent;
  let fixture: ComponentFixture<BoqmainitemreportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqmainitemreportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqmainitemreportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
