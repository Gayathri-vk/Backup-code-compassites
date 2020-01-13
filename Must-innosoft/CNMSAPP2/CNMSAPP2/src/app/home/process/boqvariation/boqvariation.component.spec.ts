import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqvariationComponent } from './boqvariation.component';

describe('BoqvariationComponent', () => {
  let component: BoqvariationComponent;
  let fixture: ComponentFixture<BoqvariationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqvariationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqvariationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
