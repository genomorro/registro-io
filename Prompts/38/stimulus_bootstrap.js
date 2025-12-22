import { startStimulusApp } from '@symfony/stimulus-bundle';
import ConditionalFieldController from './controllers/conditional-field_controller.js';

const app = startStimulusApp();
// register any custom, 3rd party controllers here
app.register('conditional-field', ConditionalFieldController);
