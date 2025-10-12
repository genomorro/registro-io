<?php

namespace App\Command;

use App\Entity\Appointment;
use App\Entity\Patient;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'app:populate-database',
    description: 'Populates the database with test data.',
)]
class PopulateDatabaseCommand extends Command
{
    public function __construct(private readonly EntityManagerInterface $entityManager)
    {
        parent::__construct();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $io->title('Resetting database...');
        $this->entityManager->getConnection()->executeStatement('SET FOREIGN_KEY_CHECKS=0;');
        $this->entityManager->getConnection()->executeStatement('TRUNCATE TABLE appointment');
        $this->entityManager->getConnection()->executeStatement('TRUNCATE TABLE patient');
        $this->entityManager->getConnection()->executeStatement('SET FOREIGN_KEY_CHECKS=1;');
        $io->success('Database reset.');


        $io->title('Populating database with test data...');

        $patient1 = new Patient();
        $patient1->setName('John Doe');
        $patient1->setFile('JD001');
        $patient1->setDisability(false);
        $this->entityManager->persist($patient1);

        $patient2 = new Patient();
        $patient2->setName('Jane Doe');
        $patient2->setFile('JD002');
        $patient2->setDisability(true);
        $this->entityManager->persist($patient2);

        $patient3 = new Patient();
        $patient3->setName('Peter Pan');
        $patient3->setFile('PP001');
        $patient3->setDisability(false);
        $this->entityManager->persist($patient3);

        $appointment1 = new Appointment();
        $appointment1->setPatient($patient1);
        $appointment1->setPlace('Hospital');
        $appointment1->setType('Check-up');
        $appointment1->setDateAt(new \DateTimeImmutable('today'));
        $this->entityManager->persist($appointment1);

        $appointment2 = new Appointment();
        $appointment2->setPatient($patient1);
        $appointment2->setPlace('Clinic');
        $appointment2->setType('Follow-up');
        $appointment2->setDateAt(new \DateTimeImmutable('yesterday'));
        $this->entityManager->persist($appointment2);

        $appointment3 = new Appointment();
        $appointment3->setPatient($patient2);
        $appointment3->setPlace('Hospital');
        $appointment3->setType('Surgery');
        $appointment3->setDateAt(new \DateTimeImmutable('today'));
        $this->entityManager->persist($appointment3);
        
        $appointment4 = new Appointment();
        $appointment4->setPatient($patient2);
        $appointment4->setPlace('Home');
        $appointment4->setType('Visit');
        $appointment4->setDateAt(new \DateTimeImmutable('tomorrow'));
        $this->entityManager->persist($appointment4);

        $this->entityManager->flush();

        $io->success('Database populated.');

        return Command::SUCCESS;
    }
}