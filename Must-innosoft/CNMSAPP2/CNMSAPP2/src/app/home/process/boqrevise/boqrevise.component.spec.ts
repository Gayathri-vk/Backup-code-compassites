import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqreviseComponent } from './boqrevise.component';

describe('BoqreviseComponent', () => {
  let component: BoqreviseComponent;
  let fixture: ComponentFixture<BoqreviseComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqreviseComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqreviseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
