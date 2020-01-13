import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqcriticalpathreportComponent } from './boqcriticalpathreport.component';

describe('BoqcriticalpathreportComponent', () => {
  let component: BoqcriticalpathreportComponent;
  let fixture: ComponentFixture<BoqcriticalpathreportComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqcriticalpathreportComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqcriticalpathreportComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
