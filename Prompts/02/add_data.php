<?php

use Symfony\Component\Dotenv\Dotenv;

require __DIR__.'/vendor/autoload.php';

// Load environment variables from .env file
(new Dotenv())->bootEnv(__DIR__.'/.env');

use App\Entity\Patient;
use App\Entity\Appointment;
use App\Kernel;
use Doctrine\ORM\EntityManagerInterface;

$kernel = new Kernel('dev', true);
$kernel->boot();

$container = $kernel->getContainer();
$entityManager = $container->get('doctrine.orm.entity_manager');

// Create Patient 1
$patient1 = new Patient();
$patient1->setFile('P001');
$patient1->setName('John Doe');
$patient1->setDisability(false);
$entityManager->persist($patient1);

// Create Patient 2
$patient2 = new Patient();
$patient2->setFile('P002');
$patient2->setName('Jane Smith');
$patient2->setDisability(true);
$entityManager->persist($patient2);

// Create an appointment for today for Patient 1
$appointment1 = new Appointment();
$appointment1->setPatient($patient1);
$appointment1->setPlace('Clinic A');
$appointment1->setType('Check-up');
$appointment1->setDateAt(new \DateTimeImmutable('today'));
$entityManager->persist($appointment1);

// Create an appointment for today for Patient 2
$appointment2 = new Appointment();
$appointment2->setPatient($patient2);
$appointment2->setPlace('Clinic B');
$appointment2->setType('Therapy');
$appointment2->setDateAt(new \DateTimeImmutable('today'));
$entityManager->persist($appointment2);

$entityManager->flush();

echo "Sample data added successfully.\n";